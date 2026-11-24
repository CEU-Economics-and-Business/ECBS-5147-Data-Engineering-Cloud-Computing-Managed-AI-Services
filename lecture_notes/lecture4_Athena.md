# Week 4 - Amazon Athena

## tl;dr

Amazon Athena is an interactive query service that lets you use standard SQL to analyze data directly in Amazon S3. You can point Athena at your data in Amazon S3, run ad-hoc queries, and get results in seconds. Athena is serverless, so there is no infrastructure to set up or manage. You pay only for the queries you run. Athena scales automatically—executing queries in parallel—so results are fast, even with large datasets and complex queries.

## In-Class Pipeline

The SQL scripts for the in-class exercise are [pipeline/1_create_database.sql](../pipeline/1_create_database.sql), [pipeline/2_raw_edits.sql](../pipeline/2_raw_edits.sql) and [pipeline/3_edits_view.sql](../pipeline/3_edits_view.sql). Replace `<username>` with your username: lowercase letters and digits only (e.g. `johndoe`). The same name is used for your S3 bucket `<username>-wikidata` and your Athena database `<username>`.

## Athena High Level Overview

- Helps you analyze unstructured, semi-structured, and structured data stored in Amazon S3.
- Examples include CSV, JSON, or columnar data formats such as Apache Parquet and Apache ORC.
- Use Athena to run ad-hoc queries using ANSI SQL, without the need to aggregate or load the data into Athena.
- Helps you visualize: Athena integrates with Amazon QuickSight for easy data visualization.
- Use Athena to generate reports or explore data with business intelligence tools or SQL clients connected with a JDBC or an ODBC driver.
- Create tables and query data in Athena based on a central metadata store.
- Serverless. Zero infrastructure. Zero administration.

## Serverless Infrastructure

Amazon Athena is serverless, so there is no infrastructure to manage. You don’t need to worry about configuration, software updates, failures, or scaling your infrastructure as your datasets and number of users grow. Athena automatically takes care of all of this for you, so you can focus on the data, not the infrastructure.

## Easy to Get Started

To get started, log into the Athena console, define your schema using the console wizard or by entering DDL statements, and immediately start querying using the built-in query editor. You can also use AWS Glue to automatically crawl data sources to discover data and populate your Data Catalog with new and modified table and partition definitions. Results are displayed in the console within seconds and automatically written to a location of your choice in S3. You can also download them to your desktop. With Athena, there’s no need for complex ETL jobs to prepare your data for analysis. This makes it easy for anyone with SQL skills to quickly analyze large-scale datasets.

## Easy to Query: Just Use Standard SQL

Amazon Athena (engine version 3) uses Trino, an open-source, distributed SQL query engine optimized for low latency, ad-hoc analysis of data. This means you can run queries against large datasets in Amazon S3 using ANSI SQL, with full support for large joins, window functions, and arrays. Athena supports a wide variety of data formats such as CSV, JSON, ORC, Avro, or Parquet. You can also connect to Athena from a wide variety of BI tools using Athena's JDBC driver.

## Pay Per Query

With Amazon Athena, you pay only for the queries that you run. You are charged based on the amount of data scanned by each query. You can get significant cost savings and performance gains by compressing, partitioning, or converting your data to a columnar format because each of those operations reduces the amount of data that Athena needs to scan to execute a query.

## Highly Available & Durable

Amazon Athena is highly available and executes queries using compute resources across multiple facilities, automatically routing queries appropriately if a particular facility is unreachable. Athena uses Amazon S3 as its underlying data store, making your data highly available and durable. Amazon S3 provides durable infrastructure to store important data and is designed for durability of 99.999999999% of objects. Your data is redundantly stored across multiple facilities and multiple devices in each facility.

## Secure

Amazon Athena allows you to control access to your data by using AWS Identity and Access Management (IAM) policies, access control lists (ACLs), and Amazon S3 bucket policies. With IAM policies, you can grant IAM users fine-grained control to your S3 buckets. By controlling access to data in S3, you can restrict users from querying it using Athena. Athena also allows you to easily query encrypted data stored in Amazon S3 and write encrypted results back to your S3 bucket. Both server-side encryption and client-side encryption are supported.

## Integrated

Amazon Athena integrates out-of-the-box with AWS Glue. With Glue Data Catalog, you will be able to create a unified metadata repository across various services, crawl data sources to discover data, populate your Data Catalog with new and modified table and partition definitions, and maintain schema versioning. You can also use Glue’s fully-managed ETL capabilities to transform data or convert it into columnar formats to optimize query performance and reduce costs. Learn more about AWS Glue.

## Federated Query

Athena enables you to run SQL queries across data stored in relational, non-relational, object, and custom data sources. You can use familiar SQL constructs to JOIN data across multiple data sources for quick analysis and store results in Amazon S3 for subsequent use. Athena executes federated queries using Athena Data Source Connectors that run on AWS Lambda. AWS has open-source data source connectors for Amazon DynamoDB, Apache HBase, Amazon DocumentDB, Amazon Redshift, AWS CloudWatch, AWS CloudWatch Metrics, and JDBC-compliant relational databases such as MySQL and PostgreSQL. You can use these connectors to run federated SQL queries in Athena. Additionally, using the Athena Query Federation SDK, you can build connectors to any data source.

## Machine Learning

You can invoke your SageMaker Machine Learning models in an Athena SQL query to run inference. The ability to use ML models in SQL queries makes complex tasks such as anomaly detection, customer cohort analysis, and sales predictions as simple as writing a SQL query. Athena makes it easy for anyone with SQL experience to run ML models deployed on Amazon SageMaker.
