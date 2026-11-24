#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["boto3"]
# ///
"""
Wikipedia Views Pipeline - Homework Self-Check Script

This script validates your homework submission before you turn it in.
Run it from the repository root directory:

    ./homework/check_submission.py <your-username>

Example:
    ./homework/check_submission.py johndoe

The script will check all requirements step by step and stop at the first error.
"""

import json
import os
import re
import sys
from pathlib import Path

# Check for boto3 before importing
try:
    import boto3
    from botocore.exceptions import ClientError, NoCredentialsError
except ImportError:
    print("=" * 66)
    print("ERROR: boto3 is not installed")
    print("=" * 66)
    print()
    print("Run the script with uv, which installs boto3 for you:")
    print("    uv run homework/check_submission.py <your-username>")
    sys.exit(1)


# Constants
REQUIRED_FILES = [
    ("extract_views.ipynb", "Part 1", "the notebook with your ETL pipeline"),
    ("lambda_extract_views.py", "Part 3", "your Lambda function code"),
    ("4_raw_views.sql", "Part 2", "the CREATE EXTERNAL TABLE statement"),
    ("5_views_view.sql", "Part 2", "the CREATE VIEW statement"),
]

AWS_REGION = "eu-west-1"


def print_header():
    """Print the script header."""
    print()
    print("╔" + "═" * 64 + "╗")
    print("║" + "Wikipedia Views Pipeline - Homework Self-Check".center(64) + "║")
    print("║" + "This is an optional vibe-coded self-checker".center(64) + "║")
    print("║" + "It can make errors".center(64) + "║")
    print("╚" + "═" * 64 + "╝")
    print()


def print_error(title: str, message: str):
    """Print an error message and exit."""
    print()
    print("═" * 66)
    print(f"ERROR: {title}")
    print("═" * 66)
    print()
    print(message)
    print()
    print("Fix this issue and re-run the check script.")
    print()
    sys.exit(1)


def print_success():
    """Print success message."""
    print()
    print("═" * 66)
    print("SUCCESS! All checks passed.")
    print("═" * 66)
    print()
    print("Your submission appears to be complete. Next steps:")
    print("1. Commit all files in homework/ to Git")
    print("2. Push to GitHub")
    print()


def check_mark(message: str):
    """Print a success check mark."""
    print(f"  ✓ {message}")


def fail_mark(message: str):
    """Print a failure mark."""
    print(f"  ✗ {message}")


def step_header(step: int, total: int, description: str):
    """Print a step header."""
    print(f"\nStep {step}/{total}: {description}")


def get_homework_dir() -> Path:
    """Find the homework directory."""
    # Try relative to script location
    script_dir = Path(__file__).parent
    if script_dir.name == "homework":
        return script_dir

    # Try current directory
    cwd = Path.cwd()
    homework_dir = cwd / "homework"
    if homework_dir.exists():
        return homework_dir

    # Try parent of script
    if (script_dir.parent / "homework").exists():
        return script_dir.parent / "homework"

    print_error(
        "Cannot find homework directory",
        "Please run this script from the repository root directory:\n"
        "    python homework/check_submission.py <username>",
    )
    return Path()  # Never reached


def capitalize_username(username: str) -> str:
    """Capitalize first letter of username for AWS resource names."""
    if not username:
        return username
    return username[0].upper() + username[1:]


# =============================================================================
# Step 1: Prerequisites
# =============================================================================
def check_prerequisites(username: str) -> boto3.Session:
    """Check that AWS credentials are configured."""
    step_header(1, 9, "Checking prerequisites...")

    check_mark("boto3 is available")

    try:
        session = boto3.Session(region_name=AWS_REGION)
        sts = session.client("sts")
        sts.get_caller_identity()
        check_mark(f"AWS credentials configured (region: {AWS_REGION})")
    except NoCredentialsError:
        fail_mark("AWS credentials not found")
        print_error(
            "AWS credentials not configured",
            "Please configure your AWS credentials. You can do this by:\n"
            "1. Running 'aws configure' and entering your credentials\n"
            "2. Or setting AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables\n\n"
            "Make sure you're using the credentials for the class AWS account.",
        )
    except ClientError as e:
        fail_mark("AWS credentials invalid")
        print_error("AWS credentials error", f"Could not authenticate with AWS:\n{e}")

    return session


# =============================================================================
# Step 2: Local Files
# =============================================================================
def check_local_files(homework_dir: Path):
    """Check that all required files exist."""
    step_header(2, 9, "Checking local files...")

    for filename, part, description in REQUIRED_FILES:
        filepath = homework_dir / filename
        if filepath.exists():
            check_mark(f"homework/{filename} exists")
        else:
            fail_mark(f"homework/{filename} - FILE NOT FOUND")
            print_error(
                "Missing required file",
                f"The file 'homework/{filename}' was not found.\n\n"
                f"This file should contain {description}.\n"
                f"See {part} of the assignment for details.",
            )


# =============================================================================
# Step 3: Lambda Code Validation
# =============================================================================
def check_lambda_code(homework_dir: Path, username: str):
    """Validate the Lambda code without revealing solutions."""
    step_header(3, 9, "Checking Lambda code structure...")

    filepath = homework_dir / "lambda_extract_views.py"
    content = filepath.read_text()

    # Check for lambda_handler function
    if "def lambda_handler" not in content:
        fail_mark("lambda_handler function not found")
        print_error(
            "Missing lambda_handler function",
            "Your Lambda code must contain a function named 'lambda_handler'.\n"
            "This is the entry point that AWS Lambda calls when invoking your function.\n\n"
            "See Part 3 of the assignment and the edits Lambda for reference.",
        )
    check_mark("lambda_handler function defined")

    # Check imports
    required_imports = ["boto3", "requests", "datetime", "json"]
    for imp in required_imports:
        if f"import {imp}" not in content:
            fail_mark(f"Missing import: {imp}")
            print_error(
                f"Missing import statement",
                f"Your Lambda code should import '{imp}'.\n"
                "Look at the edits Lambda (lambda_extract_edits.py) for reference.",
            )
    check_mark("Required imports present (boto3, requests, datetime, json)")

    # Check bucket reference
    bucket_name = f"{username}-wikidata"
    if bucket_name not in content:
        fail_mark(f"Bucket name '{bucket_name}' not found in code")
        print_error(
            "Incorrect bucket name in Lambda code",
            f"Your Lambda code should reference the bucket '{bucket_name}'.\n\n"
            f"Have you passed the correct username to the script? You passed '{username}'\n\n"
            "Make sure the S3_WIKI_BUCKET variable matches your username.\n"
            "The bucket name format is: <username>-wikidata",
        )
    check_mark(f"Bucket name '{bucket_name}' referenced")

    # Check for date parameter handling
    if "event.get" not in content and "event[" not in content:
        fail_mark("No event parameter handling found")
        print_error(
            "Missing date parameter handling",
            "Your Lambda should accept an optional date parameter from the event.\n"
            "Look at the edits Lambda for how to handle the event parameter.\n\n"
            'The Lambda should work with {"date": "YYYY-MM-DD"} and with {} (empty).',
        )
    check_mark("Event parameter handling present")


# =============================================================================
# Step 4: SQL File Validation
# =============================================================================
def check_sql_files(homework_dir: Path, username: str):
    """Validate SQL files without revealing solutions."""
    step_header(4, 9, "Checking SQL files...")

    # Check 4_raw_views.sql
    raw_sql = (homework_dir / "4_raw_views.sql").read_text().upper()

    if "CREATE EXTERNAL TABLE" not in raw_sql:
        fail_mark("CREATE EXTERNAL TABLE not found in 4_raw_views.sql")
        print_error(
            "Missing CREATE EXTERNAL TABLE",
            "The file 4_raw_views.sql should contain a CREATE EXTERNAL TABLE statement.\n"
            "Look at 2_raw_edits.sql in the pipeline folder for reference.",
        )
    check_mark("4_raw_views.sql contains CREATE EXTERNAL TABLE")

    if "RAW_VIEWS" not in raw_sql:
        fail_mark("Table name 'raw_views' not found")
        print_error(
            "Incorrect table name",
            "The table should be named 'raw_views'.\n" "See Part 2 of the assignment for the required table name.",
        )
    check_mark("Table name 'raw_views' present")

    if "JSONSERDE" not in raw_sql.replace(" ", "").replace(".", ""):
        fail_mark("JSON SerDe not found")
        print_error(
            "Missing JSON SerDe",
            "Your table should use the JSON SerDe for reading JSON Lines files.\n"
            "Look at 2_raw_edits.sql for the correct ROW FORMAT SERDE clause.",
        )
    check_mark("JSON SerDe specified")

    bucket_name = f"{username}-wikidata"
    if bucket_name.upper() not in raw_sql.replace("_", "").replace("-", ""):
        # More lenient check - just check username is there
        if username.upper() not in raw_sql:
            fail_mark(f"S3 location does not reference your bucket")
            print_error(
                "Incorrect S3 location",
                f"The LOCATION should point to your S3 bucket: s3://{bucket_name}/raw-views/\n"
                "Make sure you replace <username> with your actual username.",
            )
    check_mark("S3 location references correct bucket")

    # Check 5_views_view.sql
    view_sql = (homework_dir / "5_views_view.sql").read_text().upper()

    if "CREATE VIEW" not in view_sql:
        fail_mark("CREATE VIEW not found in 5_views_view.sql")
        print_error(
            "Missing CREATE VIEW",
            "The file 5_views_view.sql should contain a CREATE VIEW statement.\n"
            "Look at 3_edits_view.sql in the pipeline folder for reference.",
        )
    check_mark("5_views_view.sql contains CREATE VIEW")

    # Check for view name - be flexible about schema prefix
    if ".VIEWS" not in view_sql and "VIEWS AS" not in view_sql.replace(" ", ""):
        fail_mark("View name 'views' not found")
        print_error(
            "Incorrect view name",
            "The view should be named 'views'.\n" "See Part 2 of the assignment for the required view name.",
        )
    check_mark("View name 'views' present")

    if "ORDER BY" not in view_sql:
        fail_mark("ORDER BY clause not found")
        print_error(
            "Missing ORDER BY clause",
            "Your view should include an ORDER BY clause.\n"
            "See Part 2: records should be ordered by date (primary) and rank (secondary).",
        )
    check_mark("ORDER BY clause present")


# =============================================================================
# Step 5: S3 Bucket & Data
# =============================================================================
def check_s3_data(session: boto3.Session, username: str):
    """Check S3 bucket and data files."""
    step_header(5, 9, "Checking S3 bucket and data...")

    s3 = session.client("s3")
    bucket_name = f"{username}-wikidata"

    # Check bucket exists
    try:
        s3.head_bucket(Bucket=bucket_name)
        check_mark(f"Bucket '{bucket_name}' exists")
    except ClientError as e:
        error_code = e.response.get("Error", {}).get("Code", "")
        if error_code == "404":
            fail_mark(f"Bucket '{bucket_name}' not found")
            print_error(
                "S3 bucket not found",
                f"The bucket '{bucket_name}' does not exist.\n\n"
                "Make sure you:\n"
                "1. Created the bucket in Part 1 of the edits exercise\n"
                "2. Are using the correct username\n"
                "3. Are connected to the correct AWS account",
            )
        elif error_code == "403":
            fail_mark(f"Access denied to bucket '{bucket_name}'")
            print_error(
                "S3 bucket access denied",
                f"You don't have permission to access bucket '{bucket_name}'.\n\n"
                "This might mean:\n"
                "1. The bucket belongs to someone else\n"
                "2. Your AWS credentials are for a different account",
            )
        else:
            fail_mark(f"Error checking bucket: {e}")
            print_error("S3 error", f"Could not check bucket:\n{e}")

    # List raw-views files
    try:
        response = s3.list_objects_v2(Bucket=bucket_name, Prefix="raw-views/")
        files = [obj["Key"] for obj in response.get("Contents", []) if obj["Key"].endswith(".json")]

        if not files:
            fail_mark("No data files found in raw-views/")
            print_error(
                "No data files in S3",
                f"No .json files found in s3://{bucket_name}/raw-views/\n\n"
                "Make sure you ran your notebook to upload data.\n"
                "The files should be named: raw-views-YYYY-MM-DD.json",
            )

        check_mark(f"Found {len(files)} data file(s) in raw-views/")

        if len(files) < 3:
            fail_mark(f"Only {len(files)} file(s) found, need at least 3")
            print_error(
                "Not enough data files",
                f"Found {len(files)} file(s), but you need at least 3.\n\n"
                "The assignment requires you to run the notebook for 3 different dates.\n"
                "Re-run your notebook with different DATE_PARAM values.",
            )
        check_mark("At least 3 data files present (ran for multiple dates)")

        # Sample and validate one file
        sample_file = files[0]
        response = s3.get_object(Bucket=bucket_name, Key=sample_file)
        content = response["Body"].read().decode("utf-8")
        lines = content.strip().split("\n")

        if not lines:
            fail_mark(f"File {sample_file} is empty")
            print_error(
                "Empty data file",
                f"The file {sample_file} appears to be empty.\n"
                "Check that your notebook is correctly uploading data.",
            )

        # Parse first line as JSON
        try:
            record = json.loads(lines[0])
        except json.JSONDecodeError as e:
            fail_mark(f"Invalid JSON in {sample_file}")
            print_error(
                "Invalid JSON format",
                f"Could not parse JSON from {sample_file}:\n{e}\n\n"
                "Make sure your notebook outputs valid JSON Lines format.\n"
                "Each line should be a complete JSON object.",
            )

        # Check for expected fields
        expected_fields = ["title", "views", "rank", "date", "retrieved_at"]
        missing_fields = [f for f in expected_fields if f not in record]
        if missing_fields:
            fail_mark(f"Missing fields in data: {missing_fields}")
            print_error(
                "Missing fields in data",
                f"Your JSON records are missing these required fields: {missing_fields}\n\n"
                "Each record should have: title, views, rank, date, retrieved_at\n"
                "See Part 1 of the assignment for the required fields.",
            )

        check_mark("Data format is valid (JSON Lines with required fields)")

    except ClientError as e:
        fail_mark(f"Error listing S3 objects: {e}")
        print_error("S3 error", f"Could not list objects in bucket:\n{e}")


# =============================================================================
# Step 6: Lambda Function Configuration
# =============================================================================
def check_lambda_config(session: boto3.Session, username: str):
    """Check Lambda function exists and is configured correctly."""
    step_header(6, 9, "Checking Lambda function configuration...")

    lambda_client = session.client("lambda")
    function_name = f"WikiViewsLambda{capitalize_username(username)}"

    try:
        response = lambda_client.get_function(FunctionName=function_name)
        config = response["Configuration"]
        check_mark(f"Lambda function '{function_name}' exists")
    except ClientError as e:
        if e.response["Error"]["Code"] == "ResourceNotFoundException":
            fail_mark(f"Lambda function '{function_name}' not found")
            print_error(
                "Lambda function not found",
                f"Could not find Lambda function named '{function_name}'.\n\n"
                "Make sure you:\n"
                f"1. Created the function with exact name: WikiViewsLambda{capitalize_username(username)}\n"
                "2. Note: The first letter of your username should be capitalized\n"
                "3. Deployed it to the correct AWS region (eu-west-1)",
            )
        else:
            print_error("Lambda error", f"Error checking Lambda function:\n{e}")

    # Check runtime
    runtime = config.get("Runtime", "")
    if not runtime.startswith("python3.13"):
        fail_mark(f"Runtime is '{runtime}', expected 'python3.13'")
        print_error(
            "Incorrect Lambda runtime",
            f"Your Lambda is using runtime '{runtime}'.\n"
            "The assignment requires Python 3.13.\n\n"
            "Update the runtime in the Lambda console under 'Runtime settings'.",
        )
    check_mark(f"Runtime is Python 3.13 ({runtime})")

    # Check timeout
    timeout = config.get("Timeout", 0)
    if timeout < 30:
        fail_mark(f"Timeout is {timeout}s, should be at least 30s")
        print_error(
            "Lambda timeout too short",
            f"Your Lambda timeout is {timeout} seconds.\n"
            "The assignment requires at least 30 seconds.\n\n"
            "Update this in Configuration -> General configuration -> Timeout.",
        )
    check_mark(f"Timeout is {timeout}s (>= 30s required)")

    # Check role
    role_arn = config.get("Role", "")
    if "LambdaS3ExecutionRole" not in role_arn:
        fail_mark("Execution role is not LambdaS3ExecutionRole")
        print_error(
            "Incorrect execution role",
            "Your Lambda should use the 'LambdaS3ExecutionRole' role.\n\n"
            "Update this in Configuration -> Permissions -> Execution role.\n"
            "This role provides S3 write access needed to upload data.",
        )
    check_mark("Execution role is LambdaS3ExecutionRole")

    # Check for layer
    layers = config.get("Layers", [])
    has_pandas_layer = any("AWSSDKPandas" in layer.get("Arn", "") for layer in layers)
    if not has_pandas_layer:
        fail_mark("AWSSDKPandas layer not attached")
        print_error(
            "Missing Lambda layer",
            "Your Lambda should have the 'AWSSDKPandas-Python313' layer attached.\n\n"
            "Add this in the Lambda console under Layers -> Add a layer.\n"
            "Select 'AWS layers' and choose AWSSDKPandas-Python313 (version 5).",
        )
    check_mark("AWSSDKPandas layer attached")


# =============================================================================
# Step 7: Lambda Execution
# =============================================================================
def check_lambda_execution(session: boto3.Session, username: str):
    """Test Lambda execution with and without parameters."""
    step_header(7, 9, "Testing Lambda execution...")

    lambda_client = session.client("lambda")
    function_name = f"WikiViewsLambda{capitalize_username(username)}"

    # Test with date parameter
    test_date = "2025-10-15"
    print(f"  Testing with date parameter '{test_date}'...")

    try:
        response = lambda_client.invoke(
            FunctionName=function_name,
            InvocationType="RequestResponse",
            Payload=json.dumps({"date": test_date}),
        )

        payload = json.loads(response["Payload"].read())

        if response.get("FunctionError"):
            fail_mark(f"Lambda execution failed with error")
            error_msg = payload.get("errorMessage", "Unknown error")
            print_error(
                "Lambda execution error",
                f'Your Lambda failed when called with {{"date": "{test_date}"}}:\n\n'
                f"Error: {error_msg}\n\n"
                "Check the CloudWatch logs for your Lambda for more details.\n"
                "Common issues:\n"
                "- API URL format incorrect\n"
                "- JSON parsing error\n"
                "- S3 permission issues",
            )

        status_code = payload.get("statusCode")
        if status_code != 200:
            fail_mark(f"Lambda returned status {status_code}, expected 200")
            print_error(
                "Lambda returned error status",
                f"Your Lambda returned statusCode {status_code} instead of 200.\n\n"
                f"Response: {payload}\n\n"
                "Check your Lambda code for error handling.",
            )

        body = payload.get("body", "")
        if "raw-views" not in body:
            fail_mark("Response doesn't mention raw-views")
            print_error(
                "Unexpected Lambda response",
                f"Your Lambda response doesn't mention 'raw-views':\n{body}\n\n"
                "Make sure your Lambda uploads to the raw-views/ prefix in S3.",
            )

        check_mark(f"Execution with date '{test_date}' succeeded (status 200)")

    except ClientError as e:
        fail_mark(f"Error invoking Lambda: {e}")
        print_error("Lambda invocation error", f"Could not invoke Lambda:\n{e}")

    # Test without parameters (should default to 21 days ago)
    print("  Testing without parameters (should use default date)...")

    try:
        response = lambda_client.invoke(
            FunctionName=function_name,
            InvocationType="RequestResponse",
            Payload=json.dumps({}),
        )

        payload = json.loads(response["Payload"].read())

        if response.get("FunctionError"):
            fail_mark("Lambda execution failed with empty event")
            error_msg = payload.get("errorMessage", "Unknown error")
            print_error(
                "Lambda execution error",
                "Your Lambda failed when called with an empty event {}:\n\n"
                f"Error: {error_msg}\n\n"
                "Your Lambda should default to 21 days ago when no date is provided.\n"
                "Check that you handle the case when 'date' is not in the event.",
            )

        status_code = payload.get("statusCode")
        if status_code != 200:
            fail_mark(f"Lambda returned status {status_code}, expected 200")
            print_error(
                "Lambda returned error status",
                f"With empty event, Lambda returned statusCode {status_code}.\n\n"
                f"Response: {payload}\n\n"
                "Make sure your Lambda handles missing date parameter correctly.",
            )

        check_mark("Execution without parameters succeeded (status 200)")

    except ClientError as e:
        fail_mark(f"Error invoking Lambda: {e}")
        print_error("Lambda invocation error", f"Could not invoke Lambda:\n{e}")


# =============================================================================
# Step 8: EventBridge Schedule
# =============================================================================
def check_eventbridge(session: boto3.Session, username: str):
    """Check EventBridge schedule configuration."""
    step_header(8, 9, "Checking EventBridge schedule...")

    scheduler = session.client("scheduler")
    schedule_name = f"WikiViewsScheduler{capitalize_username(username)}"

    try:
        response = scheduler.get_schedule(Name=schedule_name)
        check_mark(f"Schedule '{schedule_name}' exists")
    except ClientError as e:
        if e.response["Error"]["Code"] == "ResourceNotFoundException":
            fail_mark(f"Schedule '{schedule_name}' not found")
            print_error(
                "EventBridge schedule not found",
                f"Could not find schedule named '{schedule_name}'.\n\n"
                "Make sure you:\n"
                f"1. Created the schedule with exact name: WikiViewsScheduler{capitalize_username(username)}\n"
                "2. Note: The first letter of your username should be capitalized\n"
                "3. Created it in the correct AWS region (eu-west-1)\n\n"
                "See Part 4 of the assignment for EventBridge setup instructions.",
            )
        else:
            print_error("EventBridge error", f"Error checking schedule:\n{e}")

    # Check state
    state = response.get("State", "")
    if state != "ENABLED":
        fail_mark(f"Schedule state is '{state}', should be 'ENABLED'")
        print_error(
            "Schedule not enabled",
            f"Your schedule state is '{state}' but should be 'ENABLED'.\n"
            "Enable the schedule in the EventBridge console.",
        )
    check_mark("Schedule is ENABLED")

    # Check cron expression
    schedule_expr = response.get("ScheduleExpression", "")
    expected_cron = "cron(10 0 * * ? *)"
    if schedule_expr != expected_cron:
        fail_mark(f"Cron expression is '{schedule_expr}'")
        print_error(
            "Incorrect cron expression",
            f"Your schedule expression is: {schedule_expr}\n"
            f"Expected: {expected_cron}\n\n"
            "This should run daily at 0:10 AM UTC.\n"
            "See Part 4 of the assignment for the correct cron expression.",
        )
    check_mark(f"Cron expression correct ({expected_cron})")

    # Check flexible time window
    flex_window = response.get("FlexibleTimeWindow", {})
    if flex_window.get("Mode") != "FLEXIBLE":
        fail_mark("Flexible time window not configured")
        print_error(
            "Missing flexible time window",
            "Your schedule should have a flexible time window of 1 hour.\n"
            "This is a cost-saving measure mentioned in Part 4.",
        )
    check_mark("Flexible time window configured")

    # Check target is Lambda
    target = response.get("Target", {})
    target_arn = target.get("Arn", "")
    expected_lambda = f"WikiViewsLambda{capitalize_username(username)}"
    if expected_lambda not in target_arn:
        fail_mark(f"Target is not your Lambda function")
        print_error(
            "Incorrect target",
            f"The schedule target should be your Lambda function.\n"
            f"Expected: {expected_lambda}\n"
            f"Found: {target_arn}\n\n"
            "Update the schedule target to point to your Lambda function.",
        )
    check_mark(f"Target is Lambda function")


# =============================================================================
# Step 9: Athena Tables
# =============================================================================
def run_athena_query(session: boto3.Session, database: str, query: str, output_location: str) -> dict | None:
    """Run an Athena query and wait for results. Returns column info and row count."""
    import time

    athena = session.client("athena")

    # Start query execution
    try:
        response = athena.start_query_execution(
            QueryString=query,
            QueryExecutionContext={"Database": database},
            ResultConfiguration={"OutputLocation": output_location},
        )
        query_execution_id = response["QueryExecutionId"]
    except ClientError as e:
        return {"error": f"Failed to start query: {e}"}

    # Poll for completion (max 30 seconds)
    for _ in range(30):
        try:
            status_response = athena.get_query_execution(QueryExecutionId=query_execution_id)
            state = status_response["QueryExecution"]["Status"]["State"]

            if state == "SUCCEEDED":
                break
            elif state in ("FAILED", "CANCELLED"):
                reason = status_response["QueryExecution"]["Status"].get("StateChangeReason", "Unknown")
                return {"error": f"Query {state.lower()}: {reason}"}

            time.sleep(1)
        except ClientError as e:
            return {"error": f"Failed to check query status: {e}"}
    else:
        return {"error": "Query timed out after 30 seconds"}

    # Get results
    try:
        results = athena.get_query_results(QueryExecutionId=query_execution_id)
        columns = [col["Name"] for col in results["ResultSet"]["ResultSetMetadata"]["ColumnInfo"]]
        # Subtract 1 for header row
        row_count = len(results["ResultSet"]["Rows"]) - 1
        return {"columns": columns, "row_count": row_count}
    except ClientError as e:
        return {"error": f"Failed to get results: {e}"}


def verify_athena_query(session: boto3.Session, username: str):
    """Run a test query against the views view to verify it works."""
    print("  Running Athena query to verify view...")

    database_name = username.replace("-", "_")
    bucket_name = f"{username}-wikidata"
    output_location = f"s3://{bucket_name}/athena-results/"

    query = f"SELECT * FROM {database_name}.views LIMIT 10"
    result = run_athena_query(session, database_name, query, output_location)

    if result is None:
        fail_mark("Athena query returned no result")
        print_error(
            "Athena query failed",
            "The test query returned no result.\n"
            "Check your view definition and try running the query manually in Athena.",
        )

    if "error" in result:
        fail_mark(f"Athena query failed: {result['error']}")
        print_error(
            "Athena query failed",
            f"Could not query the 'views' view:\n\n{result['error']}\n\n"
            "Common issues:\n"
            "- The view SQL has syntax errors\n"
            "- The raw_views table has no data\n"
            "- Column names don't match between table and view\n\n"
            "Try running this query manually in Athena:\n"
            f"  SELECT * FROM {database_name}.views LIMIT 10",
        )

    columns = result.get("columns", [])
    row_count = result.get("row_count", 0)

    check_mark(f"Athena query executed successfully ({row_count} rows returned)")

    # Check for expected columns
    expected_columns = ["title", "views", "rank", "date"]
    missing_columns = [col for col in expected_columns if col not in columns]

    if missing_columns:
        fail_mark(f"Missing columns in view: {missing_columns}")
        print_error(
            "Missing columns in view",
            f"The 'views' view is missing these columns: {missing_columns}\n\n"
            f"Found columns: {columns}\n\n"
            "Your view should include: title, views, rank, date\n"
            "Check your 5_views_view.sql file.",
        )

    check_mark(f"View has required columns: {expected_columns}")

    if row_count == 0:
        fail_mark("View returned 0 rows")
        print_error(
            "No data in view",
            "The 'views' view returned 0 rows.\n\n"
            "This likely means:\n"
            "- The raw_views table has no data, or\n"
            "- The view query filters out all rows\n\n"
            f"Check that you have data files in s3://{bucket_name}/raw-views/",
        )

    check_mark("View contains data")


def check_athena(session: boto3.Session, username: str):
    """Check Athena database, table, and view."""
    step_header(9, 9, "Checking Athena tables...")

    glue = session.client("glue")
    database_name = username.replace("-", "_")

    # Check database exists
    try:
        glue.get_database(Name=database_name)
        check_mark(f"Database '{database_name}' exists")
    except ClientError as e:
        if e.response["Error"]["Code"] == "EntityNotFoundException":
            fail_mark(f"Database '{database_name}' not found")
            print_error(
                "Athena database not found",
                f"Could not find database named '{database_name}'.\n\n"
                "Make sure you:\n"
                "1. Created the database in Athena (from the edits exercise)\n"
                "2. Are using the correct username\n"
                "3. Database name should match your username exactly",
            )
        else:
            print_error("Glue error", f"Error checking database:\n{e}")

    # Check raw_views table
    try:
        glue.get_table(DatabaseName=database_name, Name="raw_views")
        check_mark("Table 'raw_views' exists")
    except ClientError as e:
        if e.response["Error"]["Code"] == "EntityNotFoundException":
            fail_mark("Table 'raw_views' not found")
            print_error(
                "Table 'raw_views' not found",
                f"Could not find table 'raw_views' in database '{database_name}'.\n\n"
                "Make sure you ran your 4_raw_views.sql in Athena.\n"
                "Remember to replace <username> with your actual username before running.",
            )
        else:
            print_error("Glue error", f"Error checking table:\n{e}")

    # Check views view
    try:
        glue.get_table(DatabaseName=database_name, Name="views")
        check_mark("View 'views' exists")
    except ClientError as e:
        if e.response["Error"]["Code"] == "EntityNotFoundException":
            fail_mark("View 'views' not found")
            print_error(
                "View 'views' not found",
                f"Could not find view 'views' in database '{database_name}'.\n\n"
                "Make sure you ran your 5_views_view.sql in Athena.\n"
                "Remember to replace <username> with your actual username before running.",
            )
        else:
            print_error("Glue error", f"Error checking view:\n{e}")

    # Run actual Athena query to verify data and columns
    verify_athena_query(session, username)


# =============================================================================
# Main
# =============================================================================
def main():
    print_header()

    # Get username from command line
    if len(sys.argv) != 2:
        print("Usage: python homework/check_submission.py <username>")
        print()
        print("Example:")
        print("    python homework/check_submission.py johndoe")
        print()
        print("Use the same username you used for the edits pipeline.")
        sys.exit(1)

    username = sys.argv[1].lower()
    print(f"Username: {username}")

    # Find homework directory
    homework_dir = get_homework_dir()

    # Run all checks
    session = check_prerequisites(username)
    check_local_files(homework_dir)
    check_lambda_code(homework_dir, username)
    check_sql_files(homework_dir, username)
    check_s3_data(session, username)
    check_lambda_config(session, username)
    check_lambda_execution(session, username)
    check_eventbridge(session, username)
    check_athena(session, username)

    # If we get here, all checks passed!
    print_success()


if __name__ == "__main__":
    main()
