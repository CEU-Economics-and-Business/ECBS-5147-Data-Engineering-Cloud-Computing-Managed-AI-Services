#!/usr/bin/env python3
"""
Delete all Athena databases, tables, and associated S3 data.
Usage: python athena_delete_everything.py [--profile PROFILE] [--dry-run]
"""
import argparse
import time
import boto3


def run_query(athena_client, query: str, s3_output: str) -> bool:
    """Run Athena query and wait for completion."""
    try:
        start_response = athena_client.start_query_execution(
            QueryString=query,
            ResultConfiguration={"OutputLocation": s3_output},
        )
        query_id = start_response["QueryExecutionId"]

        while True:
            result = athena_client.get_query_execution(QueryExecutionId=query_id)
            state = result["QueryExecution"]["Status"]["State"]
            if state in ("RUNNING", "QUEUED"):
                time.sleep(1)
            else:
                break

        if state != "SUCCEEDED":
            reason = result["QueryExecution"]["Status"].get("StateChangeReason", "Unknown")
            print(f"    Query failed: {reason}")
            return False
        return True
    except Exception as e:
        print(f"    Error: {e}")
        return False


def get_table_s3_location(glue_client, database_name: str, table_name: str) -> str | None:
    """Get the S3 location for a Glue table."""
    try:
        response = glue_client.get_table(DatabaseName=database_name, Name=table_name)
        return response["Table"].get("StorageDescriptor", {}).get("Location")
    except Exception:
        return None


def delete_s3_prefix(s3_client, bucket: str, prefix: str, dry_run: bool = False) -> None:
    """Delete all objects under an S3 prefix."""
    try:
        paginator = s3_client.get_paginator("list_objects_v2")
        for page in paginator.paginate(Bucket=bucket, Prefix=prefix):
            if "Contents" not in page:
                continue
            objects = [{"Key": obj["Key"]} for obj in page["Contents"]]
            if objects:
                if dry_run:
                    print(f"    Would delete {len(objects)} objects from s3://{bucket}/{prefix}")
                else:
                    s3_client.delete_objects(Bucket=bucket, Delete={"Objects": objects})
                    print(f"    Deleted {len(objects)} objects from s3://{bucket}/{prefix}")
    except Exception as e:
        print(f"    Error deleting S3 data: {e}")


def parse_s3_url(s3_url: str) -> tuple[str, str] | None:
    """Parse s3://bucket/prefix into (bucket, prefix)."""
    if not s3_url or not s3_url.startswith("s3://"):
        return None
    path = s3_url[5:]
    if "/" in path:
        bucket, prefix = path.split("/", 1)
        return bucket, prefix
    return path, ""


def delete_all_athena(profile: str = "ceu", dry_run: bool = False, keep_default: bool = True) -> None:
    """Delete all Athena databases, tables, and their S3 data."""
    session = boto3.Session(profile_name=profile)
    athena_client = session.client("athena", region_name="eu-west-1")
    glue_client = session.client("glue", region_name="eu-west-1")
    s3_client = session.client("s3", region_name="eu-west-1")

    # Create a temporary output location for queries
    s3_output = "s3://de2-datasets/athena-cleanup-temp/"

    # List all databases
    print("Listing Athena databases...")
    databases = athena_client.list_databases(CatalogName="AwsDataCatalog")

    for db in databases["DatabaseList"]:
        db_name = db["Name"]

        if keep_default and db_name == "default":
            print(f"Skipping database: {db_name} (protected)")
            continue

        print(f"\nProcessing database: {db_name}")

        # List and delete tables
        try:
            tables = athena_client.list_table_metadata(
                CatalogName="AwsDataCatalog", DatabaseName=db_name
            )

            for table in tables.get("TableMetadataList", []):
                table_name = table["Name"]
                print(f"  Dropping table: {table_name}")

                # Get S3 location before dropping
                s3_location = get_table_s3_location(glue_client, db_name, table_name)

                if not dry_run:
                    run_query(athena_client, f"DROP TABLE IF EXISTS `{db_name}`.`{table_name}`", s3_output)

                # Delete S3 data
                if s3_location:
                    parsed = parse_s3_url(s3_location)
                    if parsed:
                        bucket, prefix = parsed
                        if bucket != "de2-datasets" or not prefix.startswith(""):
                            print(f"    Deleting S3 data: {s3_location}")
                            delete_s3_prefix(s3_client, bucket, prefix, dry_run)
                        else:
                            print(f"    Skipping S3 deletion for protected bucket: {s3_location}")

        except Exception as e:
            print(f"  Error listing tables: {e}")

        # Drop database
        print(f"  Dropping database: {db_name}")
        if not dry_run:
            run_query(athena_client, f"DROP DATABASE IF EXISTS `{db_name}` CASCADE", s3_output)

    print("\n=== Athena cleanup complete ===")


def main():
    parser = argparse.ArgumentParser(description="Delete all Athena databases and tables")
    parser.add_argument("--profile", default="ceu", help="AWS profile to use (default: ceu)")
    parser.add_argument("--dry-run", action="store_true", help="Show what would be deleted without actually deleting")
    parser.add_argument("--include-default", action="store_true", help="Also delete the default database")
    args = parser.parse_args()

    print(f"=== Athena Cleanup (profile: {args.profile}, dry-run: {args.dry_run}) ===")
    delete_all_athena(
        profile=args.profile,
        dry_run=args.dry_run,
        keep_default=not args.include_default
    )


if __name__ == "__main__":
    main()
