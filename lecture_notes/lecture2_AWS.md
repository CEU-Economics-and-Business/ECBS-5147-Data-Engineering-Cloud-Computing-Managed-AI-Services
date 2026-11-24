# **Week 2 - AWS**

## **Using AWS programmatically**

### **Recap video**

[AWS EC2 Recap](https://youtu.be/6FfLocjBcNE)

### **Part 1. Preamble, Regions, Availability Zones (AZ), Edge Locations**

Cloud computing allows users to quickly access vast amounts of computing resources remotely, without the need to purchase or maintain hardware. There are many cloud providers offering these services; this lecture focuses on Amazon Web Services (AWS). The fundamental concepts we discuss, however, apply broadly to other providers, such as Google Cloud and Microsoft Azure, though the terminology may differ between platforms.

### Glossary and Abbreviations

- **AWS (Amazon Web Services)** - A collection of cloud computing services provided by Amazon.
- **EC2 (Elastic Compute Cloud)** - AWS service that provides resizable cloud hosting, allowing you to configure and rent virtual machines on an as-needed basis.
- **EBS (Elastic Block Storage)** - Persistent storage solution that integrates with EC2. EBS volumes are generally SSD-backed, providing reliable storage that can only be attached to a single EC2 instance at any given time.
- **S3 (Simple Storage Service)** - Cost-effective, large-scale storage solution. Unlike EBS, which allows direct attachment as a local drive, S3 stores data as objects accessed via an API or command-line interface. While suitable for massive datasets, S3 may have certain limitations compared to EBS, such as latency.
- **SSD (Solid State Drive)** - A type of fast, reliable storage hardware generally more expensive than traditional hard drives.
- **HDD (Hard Disk Drive)** - Traditional, spinning-disk storage, offering large capacity at lower cost, but with slower performance compared to SSDs.
- **Ephemeral Storage (Instance Store Storage)** - Temporary, local storage for EC2 instances that is wiped once the instance is stopped or terminated. Instance stores may use either SSD or HDD hardware.
- **DNS (Domain Name System)** - The system that translates human-readable domain names (e.g., `example.com`) into machine-readable IP addresses (e.g., `192.0.2.1`) that computers use to communicate. Without DNS, users would have to remember numerical IP addresses to visit websites, making the internet far less accessible.
- **Domain Name** - A user-friendly address for a website (e.g., `example.com`) that is registered through domain registrars. Domain names are mapped to IP addresses using DNS, making it easier for people to access services and websites on the internet.
- **A Record (Address Record)** - A DNS record that maps a domain or subdomain to an IPv4 address (e.g., `192.0.2.1`). It is one of the most common DNS records and is used to direct traffic to web servers or other resources identified by their IP address.
- **Route 53 (DNS and Domain Management)** - AWS's DNS service that can map domain names to EC2 instances' IP addresses. You can create DNS records (like A records) to point your domain or subdomain to an EC2 instance's public IP address, allowing users to access your instance using a friendly domain name. It also includes domain registration and health checking to ensure high availability.
---

## Regions

An **AWS Region** is a physical location worldwide, consisting of multiple Availability Zones (AZs). Each region operates independently to reduce latency and increase redundancy.

**Current AWS Regions and their identifiers:**

- **US East**
  - North Virginia - `us-east-1`
  - Ohio - `us-east-2`
- **US West**
  - Northern California - `us-west-1`
  - Oregon - `us-west-2`
- **Canada**
  - Central - `ca-central-1`
- **Europe**
  - Frankfurt - `eu-central-1`
  - Ireland - `eu-west-1`
  - London - `eu-west-2`
  - Paris - `eu-west-3`
- **Asia Pacific**
  - Tokyo - `ap-northeast-1`
  - Seoul - `ap-northeast-2`
  - Osaka-Local - `ap-northeast-3`
  - Singapore - `ap-southeast-1`
  - Sydney - `ap-southeast-2`
  - Mumbai - `ap-south-1`
- **South America**
  - São Paulo - `sa-east-1`

---

## Availability Zones (AZ)

**Availability Zones (AZs)** are distinct data centers within a region, each with independent power, networking, and connectivity to ensure high availability and fault tolerance. Distributing applications across multiple AZs provides redundancy and minimizes latency.

**Regions with Multiple Availability Zones:**

- **US East**
  - Ohio (3)
  - North Virginia (6)
- **US West**
  - Oregon (3)
  - Northern California (3)
- **Canada**
  - Central (3)
- **South America**
  - São Paulo (3)
- **Europe**
  - Ireland (3)
  - Frankfurt (3)
  - London (3)
  - Paris (3)
- **Asia Pacific**
  - Singapore (3)
  - Seoul (2)
  - Tokyo (4)
  - Mumbai (2)
  - Sydney (3)
  - Beijing (2)
  - Ningxia (2)

Deploying across multiple AZs within a region is crucial for fault tolerance and performance, as this setup reduces the risk of downtime due to individual data center failures.

1. **Fault Tolerance**: By spreading workloads across multiple AZs, an application is protected from single-point failures. If one data center (or AZ) experiences issues, such as a power failure or network outage, the application can continue running in the other AZs. This setup helps prevent complete service disruptions and improves the application's resilience.

2. **Improved Performance and Reduced Latency**: Traffic can be directed to the closest or least-busy AZ, minimizing latency and balancing the load more effectively. Even if one AZ is experiencing heavy traffic, users in other AZs will still receive a responsive experience.

3. **Disaster Recovery**: A multi-AZ deployment supports business continuity planning by providing redundancy in geographically dispersed locations, making it easier to recover from localized disasters and continue operations smoothly.

For cloud-based applications, this redundancy and performance optimization ensures a high level of availability, aligning with best practices for a reliable and resilient cloud infrastructure.

[Availability zones video](https://www.youtube.com/watch?v=ET_CSqdGsYg)

## Edge Locations

**AWS Edge Locations** are geographically dispersed locations designed to cache content, enhance user experience, and reduce latency by bringing data closer to users. This is especially useful for services like AWS CloudFront and AWS CDN. For instance, if you host a website on AWS, images and other media files can be cached at multiple edge locations around the world. This setup ensures that each user’s request for an image is fulfilled from the server closest to them, significantly reducing load times and improving performance.

Each AWS region has its own set of **Availability Zones** and **Edge Locations**, which can even be located in countries that don’t have a full AWS region or availability zone. You can think of Edge Locations as independent data centers that serve cached data, making them a strategic asset for content delivery.

---

## AWS Services Overview

AWS offers a wide variety of services to support different cloud computing needs. Here are some of the most important services grouped by category:

### Compute
- **EC2 (Elastic Compute Cloud)**: Scalable cloud computing resources.
- **EC2 Container Services**: For managing containers with tools like Docker.
- **Elastic Beanstalk**: Simplifies web app deployment for developers.
- **Lambda**: Serverless computing for running code in response to events.

### Storage
- **S3 (Simple Storage Service)**: Object-based storage designed for scalability.
- **EFS (Elastic File System)**: Fully managed file storage.
- **Glacier**: Cost-effective archival storage.
- **Snowball**: A physical device for transferring large data volumes to AWS data centers.

### Databases
- **RDS (Relational Database Service)**: Managed relational databases like PostgreSQL, MySQL, and Oracle.
- **DynamoDB**: Non-relational, NoSQL database.
- **ElastiCache**: In-memory caching for improved performance.
- **Redshift**: Data warehousing and complex query capabilities.

### Networking and Content Delivery
- **VPC (Virtual Private Cloud)**: Create isolated virtual networks, control network settings, firewalls, and Availability Zones.
- **CloudFront**: Content Delivery Network (CDN) to distribute assets across global edge locations.
- **Route 53**: DNS service for domain name resolution to IP addresses.

### Machine Learning
- **SageMaker**: Managed notebook environment for building ML models.
- **Comprehend**: Sentiment analysis service.
- **Lex**: Chatbot engine powering Alexa.
- **Polly**: Text-to-speech with realistic voices.
- **Rekognition**: Image processing and recognition.
- **Amazon Translate**: Language translation.
- **Amazon Transcribe**: Speech-to-text transcription.

### Analytics
- **Athena**: Serverless SQL queries on S3 data.
- **EMR (Elastic MapReduce)**: For processing large datasets with tools like Hadoop.
- **Kinesis**: Ingests large amounts of streaming data.
- **Kinesis Video Streams**: Captures and analyzes video streams.
- **QuickSight**: Business Intelligence tool.
- **Glue**: ETL tool for data transformation.

### Security, Identity, and Compliance
- **IAM (Identity and Access Management)**: Manages user permissions and access.

### Application Integration
- **SNS (Simple Notification Service)**: Push notification and messaging service.

### Customer Engagement
- **Simple Email Service (SES)**: Email sending service for customer outreach.

### IoT
- **IoT Core**: Collects data from connected devices.
- **IoT Device Management**: Manages IoT devices.
- **FreeRTOS**: OS for microcontrollers.

### Services You Are Expected to Know
For this course, focus on understanding the following AWS services:
- **EC2**
- **S3, Glacier, EBS**
- **Transcribe, Translate, Comprehend, Rekognition, Polly**

---

## Part 2: Amazon S3 (Simple Storage Service)

**Amazon S3** is a secure, durable, and highly scalable storage service. It allows you to store and retrieve unlimited amounts of data from anywhere on the internet. S3 is object-based, which means data is stored as objects within *buckets* (like folders for organizing files).

### Key Features of S3:
- **Object-based Storage**: Each object can be up to 5TB in size.
- **Components of an Object**:
  - **Key**: Name of the object.
  - **Value**: Data itself (a sequence of bits).
  - **Version ID**: For versioning, allowing multiple versions of a file.
  - **Metadata**: Data about the data, such as creator or last modified date.
  - **Subresources**: Access control lists, torrent links, etc.
- **Unlimited Storage**: S3 has no limit on the amount of data you can store.
- **Buckets**: The container for objects; each bucket must have a unique name globally and is accessible via a unique web address.
- **Successful Uploads**: A successful file upload returns an HTTP 200 status code.

AWS S3’s scalable and flexible nature makes it ideal for storing static assets, backups, data for applications, and more.

[Video 1 - S3 Basics](https://youtu.be/f9hXcxHnQuE)

[Video 2 - S3 Netflix Demo](https://youtu.be/06AQA3xXXLA)

## Data Consistency for S3

### Consistency Models in S3
- **Strong Read-After-Write Consistency**: 
  Since December 2020, S3 provides strong read-after-write consistency for all `PUT`, `DELETE` and `LIST` operations. When you upload a new object, overwrite an existing one, or delete one, any subsequent read (or listing) immediately reflects the change—you will never get a stale version.

### S3 Guarantees
- **Availability**: S3 is built for **99.99% availability**.
- **Durability**: Amazon guarantees **99.999999999% durability** (11 nines) for data stored in S3.

---

## S3 Features Overview

- **Tiered Storage Options**: Different storage classes for various access needs.
- **Lifecycle Management**: Policies for automatic data migration across storage classes.
- **Versioning**: Maintains multiple versions of objects, helping with recovery.
- **Encryption**: Data can be encrypted both in transit and at rest.
- **Access Control**: Secure your data using Access Control Lists (ACLs) and bucket policies.

---

## S3 Storage Classes

| Storage Class                  | Description                                                                                                                         |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| **S3 Standard**                | 99.99% availability, 11 nines durability, redundant storage across multiple facilities. Supports loss tolerance across two facilities. |
| **S3 - IA (Infrequent Access)** | Designed for infrequent access but immediate retrieval when needed. Lower storage costs with additional retrieval fees.               |
| **S3 - One Zone-IA**           | Low-cost storage in a single availability zone, suitable for infrequent access with reduced resilience.                            |
| **S3 - Intelligent Tiering**   | Automatically optimizes costs by moving data to the most cost-effective access tier based on usage patterns.                        |
| **S3 - Glacier**               | Low-cost archive storage with retrieval times configurable from minutes to hours.                                                   |
| **S3 - Glacier Deep Archive**  | Lowest-cost storage for data where retrieval times of 12 hours are acceptable.                                                     |

---

## S3 Charges

AWS S3 charges based on:
- **Storage**: Based on the amount of data stored.
- **Requests**: Charges per request (e.g., GET, PUT).
- **Storage Management**: Costs for lifecycle management, replication, etc.
- **Data Transfer**: Charges for data transferred out of S3.
- **Transfer Acceleration**: Enhanced file transfer speeds over long distances.
- **Cross-Region Replication**: Charges for automatically replicating data to a different region.

> **Note**: S3 is not suitable for installing operating systems or databases, as it is designed for object-based storage.

---

## S3 Security and Encryption

- **Default Privacy**: Newly created buckets are private by default.
- **Access Control Options**:
  - **Bucket Policies**: Define permissions at the bucket level.
  - **Access Control Lists (ACLs)**: Control access to individual objects.
- **Access Logging**: S3 buckets can be configured to generate access logs, which track all requests made to the bucket. Logs can be stored in the same bucket or another bucket, even in a different AWS account.

### Encryption
- **Encryption in Transit**: Secured with HTTPS (using RSA encryption).
- **Encryption at Rest**:
  - **SSE-KMS (Server-Side Encryption with AWS Key Management Service)**: S3 supports encryption with AWS managed keys for additional security.

### Versioning with S3
- **Version Control**: Helps maintain all versions of an object, including all changes and deletions.
- **Lifecycle Rules**: Integrates with S3 versioning for automated object management.
- **Glacier Integration**: Allows seamless archiving to Glacier for versioned objects.

---

## Part 3: EC2 - Elastic Cloud Compute

**Amazon EC2 (Elastic Cloud Compute)** provides resizable compute capacity in the cloud. EC2 allows you to launch and manage virtual servers (instances) within minutes, helping you scale your infrastructure up or down based on demand.

### Key Features of EC2:
- **Scalability**: Quickly adjust server capacity in response to changing needs.
- **Pay-As-You-Go Model**: Only pay for the compute capacity you actually use, making it a cost-effective solution.
- **Reliability**: EC2 enables developers to build applications that are resilient to common failures, providing a robust foundation for critical applications.

EC2 has fundamentally changed cloud computing by enabling businesses to access affordable, on-demand compute resources, empowering developers to deploy applications faster and more efficiently.

[How Netflix uses AWS EC2 Video](https://www.youtube.com/watch?v=izyqJPl9wW8)

[EC2 Basics Video](https://www.youtube.com/watch?v=dO1X7QG_4xw&t=3s)

## EC2 Pricing Options

### On-Demand Instances
- **Pricing**: Pay a fixed rate by the hour (or second) with no upfront commitment.
- **Use Cases**:
  - Ideal for users needing flexibility without upfront payments or long-term commitments.
  - Applications that can’t afford interruptions.
  - New applications being developed or tested on EC2.

### Reserved Instances (RIs)
- **Pricing**: Offers capacity reservation and discounts on the hourly rate for a 1- or 3-year term.
- **Use Cases**:
  - Applications with consistent or predictable usage patterns.
  - Apps requiring reserved capacity.
  - Option to make upfront payments for additional cost savings.
- **Types**:
  - **Standard RIs**: Up to 75% savings compared to On-Demand.
  - **Convertible RIs**: Up to 54% savings, with flexibility to modify instance attributes to equal or greater value.

### Spot Instances
- **Pricing**: Use spare EC2 capacity at a steep discount (up to 90%) at the current Spot price, which AWS adjusts gradually based on supply and demand (there is no bidding since 2017). AWS can reclaim the instance with a 2-minute warning.
- **Use Cases**:
  - Applications with flexible start and end times.
  - Compute needs that are feasible only at low prices.
  - Fault-tolerant, interruptible workloads (e.g., batch jobs, distributed processing); not suited for single-instance deployments that must stay up.

### Dedicated Hosts
- **Description**: A physical EC2 server dedicated to your use with physical CPUs and memory. Helps reduce costs by leveraging existing server-bound software licenses (e.g., per-CPU licenses) and supports compliance with regulatory standards.
- **Use Cases**:
  - Regulatory needs that restrict multi-tenant virtualization.
  - Licensing requirements not suited for multi-tenancy or cloud.
  - Available On-Demand (hourly) or as a reservation with up to 70% savings.

---

## EC2 Instance Types

EC2 instances offer specialized configurations for different workloads. Here’s an overview:

| Family | Specialty                 | Example Use Cases                                                                                       |
| ------ | ------------------------- | ------------------------------------------------------------------------------------------------------- |
| **F1** | FPGA                      | Genomics, financial analytics, real-time video processing, big data processing                          |
| **I3** | High-Speed Storage        | NoSQL databases, data warehousing                                                                       |
| **G3** | Graphics-Intensive        | Video encoding, 3D application streaming                                                                |
| **H1** | High Disk Throughput      | MapReduce workloads, distributed file systems like HDFS                                                 |
| **T2** | Low-Cost General Purpose  | Web servers, small databases                                                                            |
| **D2** | Dense Storage             | File servers, data warehousing, Hadoop                                                                  |
| **R4** | Memory Optimization       | Memory-intensive applications and databases                                                             |
| **M5** | General Purpose           | Application servers                                                                                     |
| **C5** | Compute Optimized         | CPU-intensive applications and databases                                                                |
| **P3** | Graphics / General GPU    | Machine learning, Bitcoin mining                                                                        |
| **X1** | Memory Optimized          | SAP HANA, Apache Spark                                                                                  |

**Mnemonic** to remember EC2 instance types: **F.I.G.H.T.D.R.M.C.P.X**
- **F** - FPGA
- **I** - IOPS
- **G** - Graphics
- **H** - High Disk Throughput
- **T** - General Purpose (think T2 Micro)
- **D** - Dense Storage
- **R** - RAM
- **M** - Main choice for general-purpose applications
- **C** - Compute
- **P** - Graphics (Pics)
- **X** - Extreme Memory

---

## Part 4: EBS - Elastic Block Storage

Amazon **EBS (Elastic Block Storage)** provides persistent block storage for EC2 instances. EBS allows you to create storage volumes and attach them to your EC2 instances. Once attached, you can treat the volume like a regular block device—creating file systems, databases, or other persistent storage solutions.

- **Availability**: EBS volumes are created within a specific Availability Zone, where they’re automatically replicated for reliability.
- **TL;DR**: Think of EBS as a “disk in the cloud” that can be attached to your EC2 instances for flexible storage options.


[Elastic Block Store (EBS) Video](https://www.youtube.com/watch?v=S0gzrxsVQHo)

## EBS Volume Types

Amazon EBS offers a variety of volume types to suit different performance and cost needs. Here’s a breakdown of each:

### General Purpose SSD (GP3)
- **Use Case**: The current default volume type; balances price and performance for a wide range of workloads.
- **Performance**:
  - Provides a baseline of 3,000 IOPS and 125 MB/s regardless of volume size.
  - IOPS and throughput can be provisioned independently of size, up to 16,000 IOPS.

### General Purpose SSD (GP2)
- **Use Case**: Previous-generation general purpose volume; balances price and performance for a wide range of workloads.
- **Performance**:
  - Provides a baseline of 3 IOPS per GB.
  - Supports up to 16,000 IOPS; volumes smaller than 1 TiB can burst up to 3,000 IOPS.

### Provisioned IOPS SSD (IO1)
- **Use Case**: Ideal for I/O-intensive applications like large relational and NoSQL databases.
- **Performance**:
  - Designed for scenarios requiring more than 16,000 IOPS.
  - Capable of providing up to 64,000 IOPS per volume.
  - Offers high-performance, low-latency storage.

### Throughput Optimized HDD (ST1)
- **Use Case**: Optimized for throughput rather than IOPS, suited for big data, data warehouses, and log processing.
- **Performance**:
  - Cost-effective for high throughput applications.
  - **Note**: Cannot be used as a boot volume.

### Cold HDD (SC1)
- **Use Case**: Lowest-cost storage for infrequently accessed data, such as file servers.
- **Performance**:
  - Ideal for data that is rarely accessed and where storage costs are a priority.
  - **Note**: Cannot be used as a boot volume.

### Magnetic (Standard)
- **Use Case**: Lowest-cost per GB storage option that can be used as a boot volume. 
- **Performance**:
  - Well-suited for workloads where data is accessed infrequently and cost is a priority.
  - **Note**: The only bootable low-cost HDD option available on AWS.

---

## Part 6 - Launching an EC2 Instance

To get hands-on with AWS and launch an EC2 instance, here’s what you’ll need and the steps to follow:

### Prerequisites
- A computer with internet access, a web browser, and a terminal application (e.g., Terminal on macOS or Putty on Windows).
- Access to the Amazon EC2 console in your web browser.

### Tutorial Overview
1. **Accessing the Console**: 
   - Open the Amazon EC2 console in your web browser to configure and rent a remote computer from Amazon.
   
2. **Logging In**:
   - Use your terminal application to connect to the Amazon EC2 instance you create. This will be done over SSH (Secure Shell), allowing you to control the remote server from your command line.
   
3. **Setting Up Your Environment**:
   - You’ll configure the instance from your local computer, which can be running Windows, macOS, or Linux.
   - The remote EC2 instance will be configured as a Linux machine (though other operating systems are available).

4. **Physical Location of Your Instance**:
   - The EC2 instance will be physically located in a data center that may be far from you, depending on the AWS Region you select.
   - For this class, use the **Ireland (eu-west-1)** Region to ensure consistency across all students.

Once these steps are complete, you’ll be connected to a cloud-based Linux machine that you can control remotely, allowing you to perform compute tasks and explore the cloud environment.

![Google Data Center, The Dalles, Oregon](https://upload.wikimedia.org/wikipedia/commons/2/29/Google_Data_Center%2C_The_Dalles.jpg)

Since we are going to create an Amazon instance that is running a Linux operating system you will need to use your knowledge of working in a Linux command line. For reference, look up your notes from the Different Shapes of Data class.

## Creating an AWS Account

> *Note: You are not required to create an AWS account for this course, but here’s how you would do it if needed.*

To use AWS for the first time, follow these steps:

1. **Create an AWS Account**:
   - Visit [aws.amazon.com](https://aws.amazon.com).
   - Click on the **Sign In to the Console** button and follow the instructions to create a new account.

2. **Associate a Payment Method**:
   - During account creation, you’ll need to associate a credit card for billing purposes. This will enable you to create and run instances as described in the tutorials.

3. **Understanding AWS Billing**:
   - Review the sections on **billing**, **cost estimation**, and **resource management** to avoid unexpected charges.
   - Always ensure resources are fully shut down when not in use to prevent any unwanted charges.

---

## Logging into the AWS Console

To log into the AWS console, we’ll be using the CEU's official AWS account for this course. Follow these steps:

1. **Access the CEU AWS Login Page**:
   - Go to the [CEU AWS Console Login](https://ceu.signin.aws.amazon.com/console) page.

2. **Enter Your Login Credentials**:
   - **Username**: Use the first part of your CEU email address (e.g., for example@ceu.edu, the username is `example`).
   - **Password**: Will be provided to you (TBA).

3. **Navigating the AWS Console**:
   - Once logged in, select **EC2** from the list of AWS services. This course will focus primarily on **EC2**, with some reference to **S3**.
   - The **EC2 Console** will serve as the starting point for most activities.

With these steps, you’ll be able to log in and access the AWS services necessary for this course.

![AWS login](https://ceu-cloud-class.github.io/static/0aa6f59620fe471b8201e205717ad856/f8067/console-login.png)

## Setting Up a Security Group and Launching an EC2 Instance

Before launching and using an EC2 instance, ensure that you create a Security Group to control inbound and outbound traffic. Follow the steps below to set this up.

### Step 1: Set up key pairs

1. Go to **Services** > **EC2** > **Key Pairs**.

2. Click **Create key pair**, name it **CEU-Tutorial**, and download the `.pem` private key file (see the Key pair section below).

### Step 2: Create a Security Group

0. Go to **Services** > **EC2** > **Security Groups**.

1. Click **Create Security Group**.
   
   - **Note**: When you create an Inbound rule, an Outbound rule is created automatically. You can leave the Outbound rule empty, as Security Groups are stateful. If you allow traffic in (e.g., HTTP), it is automatically allowed out.

2. Set up rules for HTTP and SSH protocols:

   - **HTTP**  
     - IPv4: `0.0.0.0/0`
     - IPv6: `::/0`
   - **SSH**  
     - IPv4: `0.0.0.0/0`
     - IPv6: `::/0`

   ![](https://ceu-cloud-class.github.io/static/fdea9e7d0967703547364da30986b644/97808/sec-rules.png)

3. After creation, you should see two HTTP rules and two SSH rules displayed:

   - **HTTP**: `0.0.0.0/0` (IPv4) and `::/0` (IPv6)
   - **SSH**: `0.0.0.0/0` (IPv4) and `::/0` (IPv6)

4. For this course, you will need to open **port 8787 (TCP)** to allow SSH access to your instances. 

   - **Note**: Any changes made to a Security Group take effect immediately.

### Attaching the Security Group to an EC2 Instance

1. You can attach more than one Security Group to an EC2 instance if needed.
2. Once your Security Group is created, proceed to create your EC2 instance.
3. After the instance is launched, attach the Security Group by navigating to:
   - **Instances** > **Select your EC2 Instance** > **Actions** > **Networking** > **Change Security Groups**
   - Select the Security Group you created and assign it to your EC2 instance.

   ![](https://ceu-cloud-class.github.io/static/1886aa31fd1743bcfb6620379684858c/a7396/sg-assign-aws.png)

### Accessing the EC2 Dashboard and Available Services

1. To begin, go to the list of AWS services and select **EC2**.

    ![List of AWS services (select EC2 for this tutorial):](https://ceu-cloud-class.github.io/static/e4c5fc6c69613eed076ac53878f31fcc/ffe34/AWS-Services.png)

2. The EC2 Dashboard provides access to your instances, settings, and monitoring tools.

   ![The AWS EC2 dashboard:](https://ceu-cloud-class.github.io/static/f8b04228d942a2240224661db7a28eed/beade/AWS-EC2-Dashboard.png)

# Understanding AWS Regions and Cost Structure

## What is a Region?

An AWS Region is a set of compute resources that Amazon maintains, similar to a data center. Each Region corresponds to a physical warehouse of compute hardware, including computers, storage, networking, etc. 

### AWS Regions (Historical Context)

In the early days of AWS, there were nine key AWS Regions:
- **US East (N. Virginia)**
- **US West (Oregon)**
- **US West (N. California)**
- **EU (Ireland)**
- **EU (Frankfurt)**
- **Asia Pacific (Singapore)**
- **Asia Pacific (Tokyo)**
- **Asia Pacific (Sydney)**
- **South America (São Paulo)**

![AWS Regions Map](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2020/03/17/aws_regions-1.png)

**Note:** AWS has significantly expanded since then and now operates [dozens of regions worldwide](https://aws.amazon.com/about-aws/global-infrastructure/).

### Importance of Choosing the Right Region

When logged into the AWS EC2 console, you are always operating in one of these regions. The current region is displayed in the upper right corner of the console, between the User menu and the Support menu.

**Why is this important?**
1. **Instance Visibility**: When you launch an EC2 instance, it is created in a specific region. If you switch regions, you won’t see that instance unless you return to the original region.
2. **Resource Tracking**: The same applies to EBS volumes, AMIs, and other resources—they are region-specific.
3. **Cost Variation**: The cost to use AWS resources can vary by region.
4. **Network Performance**: The geographical location of the region can affect network performance, especially when transferring large amounts of data.

**Example**: If you are in the US and uploading RNA-seq data, it may not make sense to create instances in Asia Pacific (Sydney). Ideally, choose a region that is close to you or your users, while also considering costs.

### AWS EC2 Regions Menu

![EC2 Regions Menu](https://ceu-cloud-class.github.io/static/422d68324c80df38b2ba60e35570f489/5496c/AWS-EC2-Regions.png)

---

## How Much Does It Cost to Use AWS EC2 Resources?

Estimating costs for AWS resources can be complex. Generally, when you launch an EC2 instance or create an EBS or S3 volume, you are renting that resource and will be charged as long as it is reserved, regardless of actual usage.

### Example Scenario

- **Resource**: 8-core machine with 1TB of disk and 64GB of RAM.
- **Billing**: You will incur hourly charges as long as the machine is running, even if you don't log in or use it.

### Key Pricing Categories

To understand costs better, refer to the AWS EC2 Pricing list. Important categories include:
- **Free Tier**: Lightweight resources for free experimentation.
- **On-Demand Instances**: Rent by the hour.
- **Reserved Instances**: Discounts for longer-term rentals.
- **Spot Instances**: Use spare capacity at a discount; AWS can reclaim it at short notice.
- **EBS-Optimized Instances**: For high-performance file I/O.
- **Amazon Elastic Block Store**: Rent storage volumes separately from instances.

### Monthly Cost Estimation

Amazon provides a [Monthly Calculator](https://calculator.aws/#/) to help predict costs.

### Examining On-Demand Pricing

In this section, we’ll look closely at the On-Demand instance pricing. For example, let’s consider the **m3.xlarge** instance type in the **US West (Oregon)** region:

- **CPUs**: 4
- **Memory**: 15 GiB
- **Storage**: 2 x 80GB SSD drives
- **Cost**: $0.140 per hour

![EC2 Pricing Table Example](https://ceu-cloud-class.github.io/static/75105c6d2a2c169a8129b17272eec1b8/f79fa/AWS-EC2-PriceList.png)

**Note on Terminology**:
- **GiB vs. GB**: Memory is reported in GiB and storage in GB (1 GiB ≈ 1.074 GB).
- **vCPUs and ECUs**: 
  - **vCPU**: Virtual CPU; each vCPU is a hardware thread of a physical CPU core (on Graviton/ARM instances such as t4g, one vCPU is one physical core), not a whole physical CPU.
  - **ECU**: Elastic Compute Unit, which allows for comparisons between machines with different CPU generations.

### Storage Types

Storage descriptions for EC2 instances include:
- **EBS only**: Volumes that exist independently of EC2 instances; a volume is normally attached to one instance at a time (io1/io2 Multi-Attach is the exception).
- **SSD**: Solid-state drive, typically higher performance.
- **HDD**: Hard disk drive, generally less expensive but lower performance.

When an instance has a designation like **2 x 40 SSD**, it means there are two solid-state drives, each 40GB in size. The SSD and HDD drives associated with instances are considered **ephemeral** storage.

# Understanding AWS Billing

## How Does Billing Work?

AWS provides an accounting of usage and costs on a **30-day cycle**. You can access detailed information about your account in the **Billing and Cost Management** section of the User menu in the EC2 console. Additionally, the [EC2 FAQ page](https://aws.amazon.com/ec2/faqs/) has a dedicated billing section for more information.

### Key Billing Principles

Amazon describes the billing process as follows:
- You pay **only for what you use**, with **no minimum fee**.
- Pricing is calculated per **instance-hour** consumed for each instance type.
- Linux instances are billed **per second**, with a **60-second minimum**.
- There is **no Data Transfer charge** between two Amazon Web Services within the same region.
- Data transferred between AWS services in different regions is charged as **Internet Data Transfer** on both sides of the transfer.
- Usage for other AWS services is billed separately from Amazon EC2.
- **Billing begins** when EC2 initiates the boot sequence of an AMI instance and ends when the instance terminates (via command, shutdown, or failure).
- **Instance-hours** are billed while instances are in a **“running” state**. To stop incurring charges, you must **stop** or **terminate** the instance.

### Complexity of Billing

Although it sounds straightforward, AWS billing can become complex:
- **EBS usage** is billed separately from EC2 resources, despite their close relationship.
- For example, the root volume on a Linux instance often exists as an EBS volume, incurring charges whether the system is running or stopped.
- Extra EBS volumes attached to an EC2 instance also incur costs, even when the instance is stopped.
- When an instance is terminated, associated EBS volumes may or may not be automatically destroyed, depending on how the instance was configured.
- Creating a **Snapshot** of your instance saves it to EBS storage, which incurs charges as long as it exists. Creating an **AMI** (Amazon Machine Image) also stores a Snapshot.

### Cost Calculation

The total cost for an EC2 instance is calculated as follows:
- **Hourly Rate** from the pricing list × **Time** the instance was running (billed per second for Linux, with a 60-second minimum).

In the **Billing and Cost Management** section of the EC2 console, you can set up billing alerts to notify you of ongoing costs.

### Checking for Unintended Charges

If you notice a monthly fee without intentionally using resources, follow these steps:
1. Log into the **AWS EC2 console**.
2. Check for the following in each AWS Region:
   - **Running Instances**
   - **Volumes**
   - **Elastic IPs**
   - **Snapshots**

If any of these values are greater than 0, you may be billed for resources Amazon is reserving for you. Terminating or deleting these items should bring your monthly bill back to **\$0**.

---

## Necessary Steps for Launching an Instance

In the following sections, we will launch an example instance, configure it in the AWS EC2 console, and discuss important configuration concepts. We will also log into the instance once it is running.

### Launching a Virtual Server

1. Make sure you are logged into AWS and navigate to the **EC2 dashboard**.
2. Click the **Launch Instance** button.
3. Choose to run a virtual server with the latest stable version of the **Ubuntu** operating system.
4. Decide on the basic hardware specifications for your server.
5. Configure storage, security, and other necessary settings.

### Example Instance Launch

In this example, we will launch an instance in **EU West (Ireland)**. Make sure to pick the closest region to your location.

![](https://ceu-cloud-class.github.io/static/6f341d8e02e674ffc9ae015f7883b822/ba168/az-eu-west.png)

# Launching an Instance

Please make sure to select **EU West (Ireland)**.

The **Launch Instance** page is a single form with these sections: **Name and tags**, **Application and OS Images**, **Instance type**, **Key pair (login)**, **Network settings**, **Configure storage** and **Advanced details**, followed by the **Launch instance** button in the **Summary** panel. The steps below walk through these sections (the screenshots are from the older multi-page wizard, but the settings are the same).

## Step 1: Choosing an AMI (Application and OS Images)

An **AMI** (Amazon Machine Image) is a template for launching an instance. 

The AMI includes:
- A pre-configured root volume that contains an operating system (e.g., Ubuntu Linux, Windows, etc.).
- Basic configuration of storage volumes available within an instance.

The first step to launching an instance is to select an AMI. Refer to the screenshot below.

### AMI Selection Options
There are four main options when selecting an AMI:
1. **Quick Start**: A short list of basic systems chosen by Amazon as common starting points, with some degree of "official" support and testing on AWS.
2. **My AMIs**: AMIs you have created yourself, possibly using a Quick Start or Community AMI as a starting point. For example, you might start with an Ubuntu AMI, install necessary bioinformatics software, and save this configured machine as an AMI to share a complete system configuration.
3. **AWS Marketplace**: AMIs configured for certain applications by companies (often software companies). You can browse through this section to get an idea of the kinds of applications available.
4. **Community AMIs**: Thousands of AMIs created by users worldwide. These AMIs are region-specific, so ensure you search in the correct region.

For this tutorial, we will select an AMI from the **My AMIs** list: 
- The full-length description for this AMI is **Ubuntu - CEU - SSH on 8787**.
- The Root device type is **EBS** and the Virtualization type is **HVM**.

The root volume of the operating system will be installed on an EBS volume, which means information stored will persist if we stop the instance. 

Once you have selected the AMI, continue with the **Instance type** section.

![Step 1: Choose an Amazon Machine Image (AMI)](https://ceu-cloud-class.github.io/static/91f73005cf7257c893a370523bd86e12/1e496/AMI-aws.png)

---

## Step 2: Choosing an Instance Type (Instance type)

Once an AMI is selected, the next step is to choose an instance type. 

In simple terms, we decided on the operating system we want to run, and now we need to choose the hardware that it will run on.

### Instance Type Selection
For this class, pick the **t4g.micro** Instance Type (an ARM/Graviton instance matching the arm64 class AMI); it is the only instance type allowed in the class account. To get the price, note the instance type name (e.g., t4g.micro) and refer back to the EC2 pricing list.

We are given a series of options that differ in their number of CPUs, memory, pre-configured storage, and network performance. You can compare them using the **Compare instance types** link.

Once you are ready, continue with the remaining sections of the form.

![Step 2: Choose an Instance Type](https://ceu-cloud-class.github.io/static/cded756d12d31b27c7b3267f958c590f/38116/ec2nano.png)

---

## Step 3: Configuring Instance Details (Advanced details)

The instance details are configured in the **Advanced details** section at the bottom of the form, and the number of instances in the **Summary** panel. 

This step introduces many advanced concepts that will be covered only briefly here. For the most part, leaving all of these options at their default value will be fine.

### Instance Configuration Options
Using the **Number of instances** option, you could launch multiple instances of the same AMI with the same hardware configurations at the same time. However, in our example, only one instance will be launched.

- You can get a cheaper (but interruptible) rental by using the **Request Spot Instances** option.
- The **Shutdown behavior** option determines what will happen if you shutdown the instance from within the AMI (e.g., by issuing a `sudo shutdown` command in Linux).
- To prevent accidental termination of your instance, you may want to set this option to **Stop**.
- You can also enable **termination protection** to help prevent accidental termination.

These options can be adjusted later for any instance in the console.

Once you are ready, continue with the **Configure storage** section.

![Step 3: Configure Instance Details](https://ceu-cloud-class.github.io/static/4fb38bbefc39cdeaaa7ea1cc813180c5/63908/AWS-EC2-ConfigureInstanceDetails.png)

---

## Step 4: Adding Storage (Configure storage)

The **Configure storage** section sets up the disk/storage that will be available in the instance.

The starting point of this section depends on the instance type selected in Step 2. Remember that we selected an instance type with an EBS root volume during AMI selection. 

### Storage Configuration
The first volume is **8 GiB**. This is the root volume where the operating system will exist. It is set to be deleted on termination of the instance, but you could choose to keep it as well. 

- Click **Add new volume**, choose **EBS** as the Type, set the device to `/dev/sdc`, give it a size of **8 GiB**, and set the volume type to **gp3**.
- Remember to delete this extra volume after class: EBS volumes can outlive the instance and keep being billed.

Now, when we log into the instance, we will expect to find two distinct storage volumes/devices.

### Storage Options Comparison
- **EBS (Elastic Block Storage)**: 
  - Can be linked to a single instance.
  - Can persist even if the instance is destroyed.
  - Useful for writing analysis results to retain them after instance shutdown.

- **Instance Store Volumes**: 
  - Considered 'ephemeral' or transient; data is unrecoverable if the machine is stopped or terminated.
  - Can only be configured when the instance is created.

### Root Device Type
The Root device type refers to the type of volume used to store the operating system itself. This is usually a small volume (often 8 GiB) that can be either EBS or Instance Store type. 

Once you launch the AMI, you cannot change the Root device type. The **Instance Store** type may have a performance advantage, but the **EBS** type is more flexible and safer from the perspective of accidental data loss.

For beginners, we recommend using EBS for the root device type. 

Once you are ready, continue with the tags in the **Name and tags** section at the top of the form.

![Step 4a: Add Storage](https://ceu-cloud-class.github.io/static/b867080c4ace54155563cd51b21c67f7/84bc0/S3StorageRevised.png)

![This is how you add additional storage](https://ceu-cloud-class.github.io/static/4bffb08c6b05028dbbf51fa7858187dd/900ee/AWS-EC2-AddStorage2.png)
---

## Step 5: Tagging the Instance (Name and tags)

As you start to have a large number of instances running or saved, you may want to start assigning Tags to help track their usage and billing details. 

Try creating a Tag as a simple key/value pair (the **Name** field is itself a tag with the key `Name`; use **Add additional tags** for more). 

Once you are ready, continue with the **Network settings** section.

![Step 5: Tag Instance](https://ceu-cloud-class.github.io/static/4ac8c99ed1b9bc3b51097de1c8f70ee7/913a1/ec2-tags.png)

---

## Step 6: Configuring a Security Group (Network settings)

A **Security Group** controls how services and users can access your instance once it is running. 

When you launch a new instance, you can choose to configure a new Security Group and use it or select one that you created previously. You can also select a default security group.

### Security Group Settings
The purpose of Security Group settings is to determine what Inbound and Outbound network traffic will be allowed on the instance. It is highly recommended that most incoming traffic be blocked, allowing only certain services on an as-needed basis.

For example, create a Security Group called **CEU-Tutorial** that only allows incoming traffic of two types:
- **SSH** (over port 22)
- **HTTP** (over port 80)

You can restrict access to certain IP addresses for enhanced security.

Once you are ready, review the **Summary** panel.

![Step 6: Configure Security Group](https://ceu-cloud-class.github.io/static/e25fd5190ac9a8ae8e7898c7a11ff76c/6578c/Security-Group-AWS.png)

---

## Step 7: Reviewing the Instance before Launch

The **Summary** panel on the right of the form describes the configuration of your instance. Some warnings may appear, especially if you have allowed broad incoming access.

Make sure a key pair is selected in the **Key pair (login)** section (Step 8), then press the **Launch instance** button.

![Step 7: Review Instance Launch](https://ceu-cloud-class.github.io/static/3b8992582517b2c61bff9e5c25f4257b/ce0a7/Review-AWS.png)

---

## Step 8: Assigning a Key Pair (Key pair (login))

An important configuration step, done in the **Key pair (login)** section of the form before launching, is assigning a **Key Pair**. 

A Key Pair consists of two keys: a public key stored in AWS and a private key presented to you upon creation, which you must save to log into your instance later.

If this is your first instance (and you did not create one in Step 1), click **Create new key pair**. 

Once you choose a name (e.g., **CEU-Tutorial**), press the **Create key pair** button. This will download a `.pem` file that you need to store securely on your computer.

The contents of an RSA key file should look something like this:

```bash
-----BEGIN RSA PRIVATE KEY-----
...
-----END RSA PRIVATE KEY-----
```

If this is not your first instance and you have already created a key pair, you can choose to use the existing key pair.

![Select an existing Key Pair or create a new Key Pair:](https://ceu-cloud-class.github.io/static/3574efc8295c3f6f7fa5c1dfc2258906/de755/keypair-aws.png)

To prepare for logging into your instance, create a directory on your local computer and store the key file there. Here’s how to do it on a Mac:

```bash
mkdir ~/CEU-Tutorial
mv ~/Downloads/CEU-Tutorial.pem ~/CEU-Tutorial
cd ~/CEU-Tutorial
chmod 400 CEU-Tutorial.pem 
ls
```

Explanation of Commands:
-mkdir ~/CEU-Tutorial: Creates a new directory named "CEU-Tutorial" in your home directory.
-mv ~/Downloads/CEU-Tutorial.pem ~/CEU-Tutorial: Moves the downloaded Key Pair file into the newly created directory.
-cd ~/CEU-Tutorial: Changes the current directory to "CEU-Tutorial".
-chmod 400 CEU-Tutorial.pem: Changes the file permissions of your key file to ensure that only you can read it. This is a critical security measure; if you attempt to log into your instance with incorrect permissions on your key file, your login will fail.

## Step 9: Reviewing Launch Status

Once you have launched your instance, you will be presented with a review page. This page will summarize the key settings and configurations for your new EC2 instance. When you are ready, proceed to the next step by clicking the **View Instances** button.

![Step 9. Review launch status:](https://ceu-cloud-class.github.io/static/38eddaf787871174a814caf88ddc7589/647f4/AWS-EC2-LaunchStatus.png)
---

## Step 10: Examining a New Instance in the EC2 Console

You should now see the EC2 Console displaying a new instance. This view shows a table of all instances you have created in the current region. 

### Key Points to Note:

- **Instance Visibility**: When an instance is terminated, it will remain visible in this table for a brief period before being automatically removed.
- **Instance Status**: After a few minutes, your instance should achieve an **Instance State** of "running."

### Information Overview

The EC2 console provides a wealth of information, both in the table and in the detailed description view below. Familiarize yourself with the following key attributes:

- **Name**: The name you've given to your instance.
- **Instance Type**: The type of instance you have configured (e.g., t4g.micro).
- **AMI ID**: The Amazon Machine Image ID used for launching the instance.
- **Root Device Type**: The type of storage (e.g., EBS).
- **Block Devices**: The storage volumes associated with your instance.

To effectively manage your instances, pay attention to the following items:

- **Instance State**: Indicates whether your instance is running, stopped, etc.
- **Key Pair Name**: The name of the key pair associated with the instance.
- **Security Groups**: The security settings applied to your instance.
- **Public IP / Public DNS**: The IP address or DNS name used to connect to your instance.

### Instance Management

To modify an instance in the EC2 console:

1. **Select the Instance**: Use the blue checkboxes to select the instance(s) you want to modify.
2. **Actions Menu**: Perform various tasks using the **Actions** menu. You can also right-click on a single instance to obtain a similar menu.

Before logging into your instance, take a moment to explore various important sections of the EC2 console, particularly:

- **EC2 Dashboard**
- **Volumes**
- **Security Groups**
- **Key Pairs**

### Example: Console View of a New Instance

*Please do not replicate this instance here.*
![Step 10. EXAMPLE! Console view of a new Instance (Please don't replicate this instance here)](https://ceu-cloud-class.github.io/static/b74dfb4fb2bc34fa0ebee898fbb1233d/b85c3/AWS-EC2-Console.png)

**Check**

-The EC2 dashboard should now show a running Instance, Volumes, etc.
-Review new Volumes
-Review new Security Groups
-Review new Key Pairs
---

## Step 11: Connecting to Your Instance Using SSH

You've started your instance, but how do you access it? If you're not familiar with SSH (Secure Shell), it's a command-line protocol that allows you to log into a computer remotely over the network. In simple terms, it lets you use a computer that isn't physically in front of you.

### Getting Ready to Log In

1. **Open Terminal**: Launch a terminal session on your local computer (using Mac Terminal or Windows PuTTY).
2. **Navigate to Key File Location**: Change directories to where you stored your key file, `CEU-Tutorial.pem`.

    ```bash
    cd ~/CEU-Tutorial
    ```

3. **Set Permissions**: Ensure that the permissions of your key file are set correctly. Use the following command:

    ```bash
    chmod 400 CEU-Tutorial.pem
    ```

    Setting permissions correctly is essential; otherwise, you may face login issues due to bad permissions.

### Verify Instance Information

Simultaneously, view your instance in the EC2 console:

- **Check Key Pair Name**: Make sure that the Key Pair Name for this instance matches the `.pem` key file you have.
- **Obtain Public IP**: Get the Public IP value from the console to use it for the SSH command. You can also use the Public DNS value if preferred.

### Logging In

To log in to your instance, check this tutorial: [tutorial](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connect-linux-inst-ssh.html)

If successful, you will see something like this:

```bash
Welcome to Ubuntu ... (GNU/Linux ... aarch64)
...
ubuntu@ip-172-31-...:~$
```
Reflections on the above tutorial
In this example, we open a terminal command line session on our local computer. We moved to the location of my `.pem` key file. We then made sure the permissions of this file were set correctly using a `chmod` command. You only need to do this step once but there is no harm in doing it again. Then we executed an SSH command to remotely log into our AWS instance using the `Public IP`. Our SSH command included an option to use the `.pem` file to identify us as the owner of the instance. We logged into the instance as the user `ubuntu`, which is defined by default on Ubuntu AMIs.

Pitfall: One thing to watch out for is the following: the ssh address is based on your IP address and if you start and stop your instance the IP can change, changing the address you ssh into along with it (again, the value in the field Public DNS). If you've re-started your instance and are having trouble sshing, check that your address is correct.

## Step 12: Install NGINX (
__This step is only for your reference, please follow the in-class instructions__

Now that we are in, let's set up NGINX:
1. **Update the OS**: Run the following command to apply all updates to your operating system:
```bash
sudo apt update
```
2. Install NGINX: To install NGINX, run:
```bash
sudo apt install nginx
```
3. Navigate to HTML Folder: You will now have an HTML folder. Change to the directory
```bash
cd /var/www/html
```
4. List Contents: List the contents of the directory:
```bash
ls
```
   You should see one .html file.
5. Edit the HTML File: Use your preferred text editor (e.g., Nano, Vim, Emacs) to make some changes to the HTML file. For example, with Nano:
```bash   
nano index.html
 ```   
 NOTE: in case saving is not permitted, superuser authorization might be necessary as: `sudo nano index.html`

 This .html file will be displayed to the visitor's browser if they make an http request to the instance. 

## Step 13: Using Route53 to create a human-readable URL to the Instance
Installing NGINX yielded us a simple template webpage. 

Examine your EC2 Instance, as is described in step 10. Copy your Public IPv4 address and paste it into your browser as a URL. Your created website should display in your browser.

*Notice that the the IP address is pasted in as the URL*
![IPv4 of your Instance](images/Route53_IPv4_instance.png)

However, an IP address would be difficult to remember for humans. AWS Route 53 is a DNS service that maps the public IPv4 address of an Instance to a user-defined, human-readable domain. 
- *Domains are human-readable addresses used to access websites and other resources on the internet. They translate to IP addresses, which are numerical labels assigned to devices connected to a network.*

In the current example, we have an already pre-existing domain, `ceu-data.com`. We now create a URL unique to the IP address of our Instance by adding a prefix to this domain, called sub-domain.

*Navigate to Route 53 > Hosted zones*
![Route 53 Hosted zones](images/Route53_hosted_zones.png)

Here, you can see the `ceu-data.com` domain with some information. Click Create record.

![Route 53 Create Record](images/Route53_create_record.png)

Below record name, add the subdomain name of your liking. If you typed `hippopotamus`, the domain will become `hippopotamus.ceu-data.com`. We will use this domain name for our example.

Under Value, you need to type the Public IP(v4) address of your instance. This is displayed on the Console view of your created instance (this was detailed in step 10).
- *(Navigate to your own instance in AWS, DO NOT just type what you see on the example image at Step 10.)*

Leave the rest as-is, and press `Create records`.

You will be redirected to the `Hosted zones` tab, where you should see your entered subdomain name listed in the Records summary table. In our case, this is `hippopotamus.ceu-data.com`.

![Created Record added to records](images/Route53_success_create_record.png)

And if you navigate to your Instance's domain, you should see the contents of the html as was seen at the beginning of the Chapter of Step 13.

*Notice that now the human-readable URL is assigned to the Public IP address of the Instance*
![full domain Instance](images/Route53_full_domain_instance.png)
      
 ## What is the difference between the 'Start', 'Stop', 'Reboot', and 'Terminate' (Instance States)?

From the AWS EC2 console, you can change the state of each of your instances:

- The **Start** command will boot a system that has been powered down.
  
- The **Stop** command will power down the instance and is similar to performing a shutdown from within the instance (if you have configured your instance that way during creation). Do not forget that if you stop an instance with ephemeral Instance Store volumes, the contents of these volumes will be lost.

- The **Reboot** command will simply reboot the machine. This is equivalent to using a reboot command from within the instance.

- The **Terminate** command will destroy the instance and any ephemeral Instance Store volumes associated with it. If the root device is an EBS volume it may or may not be destroyed depending on how you configured the instance during creation. If there were additional EBS volumes associated with the instance and you terminate the instance, these may also be destroyed if you selected that option when they were being created. Before terminating an instance, you should think carefully about whether there is data you want to save and if so, how the volumes will behave on termination. Similarly, if you want to destroy all components of an instance, including all associated volumes, you may need to terminate the instance and then separately destroy certain volumes.

---

## Tidying up and shutting down AWS resources

Once you are done with this tutorial, you should terminate or delete all resources that were created to ensure you are not charged. Specifically, you should remove:
- Instances
- Volumes
- Snapshots

You may also decide to remove other entities that were created for demonstration purposes, including:
- Tags
- AMIs
- Security Groups
- Key Pairs

All of this can be done in the AWS EC2 console. When you are all done, the EC2 Dashboard should show 0 for all resource types except Security Groups, where a single default security configuration will remain.

---

## Further reading (Optional)

This is a basic introduction to AWS cloud computing that assumes all configuration of the instance will occur within the AWS EC2 console of your web browser and all configuration of the Ubuntu Linux system will occur by the user manually executing commands and perhaps saving the outcome as a custom AMI. For large-scale computing and complex deployments of compute infrastructure on the cloud, these methods will not be sustainable.

Here is a list of more advanced topics for discussion on how to move beyond the console and automate configuration of your system:
- Use of the AWS command line interface (CLI)
- Use of the AWS EC2 API
- Use of AWS SDKs
- Use of S3 and Glacier
- Use of Vagrant to launch AWS instances
- Use of Puppet to configure Linux systems

---

## Practice Questions

### What are the advantages of cloud computing?

**Answer**: 6 advantages:
- Trade capital expense for variable expense
- Stop guessing about capacity
- Increase speed and agility
- Stop spending money running and maintaining data centers
- Go global in minutes
- Benefit from massive economies of scale

---

### What are the types of cloud computing?

**Answer**:
- Infrastructure as a Service (IaaS)
- Platform as a Service (PaaS)
- Software as a Service (SaaS)

More here: [AWS Types of Cloud Computing](https://aws.amazon.com/types-of-cloud-computing/)

---

### What is S3 and what does it mean?

**Answer**: S3 stands for Simple Storage Service. S3 is object storage with a simple web interface to store and retrieve any amount of data from anywhere on the web.

---

### What are some usages of S3?

**Answer**: You can use Amazon S3:
- As primary storage for cloud-native applications
- As a bulk repository, or "data lake," for analytics
- As a target for backup and recovery and disaster recovery
- With serverless computing.

---

### What are the features of S3?

**Answer**: 9 features:
- **Simple**: Easy-to-use web-based management console + REST API
- **Durable**: Your data is redundantly stored across multiple facilities and multiple devices in each facility
- **Scalable**: You can store as much data as you want and access it when needed.
- **Secure**: Amazon S3 supports data transfer over SSL and automatic encryption of your data once it is uploaded. You can also configure bucket policies to manage object permissions and control access to your data using IAM
- **Available**: Designed for up to 99.99% availability of objects over a given year and is backed by the Amazon S3 Service Level Agreement, ensuring that you can rely on it when needed.
- **Low cost**: Using lifecycle policies, you can set policies to automatically migrate your data to Standard - Infrequent Access and Amazon Glacier as it ages to further reduce costs
- **Simple data transfer**: Amazon provides multiple options for cloud data migration and makes it simple and cost-effective for you to move large volumes of data into or out of Amazon S3. You can choose from network-optimized, physical disk-based, or third-party connector methods for import to or export from Amazon S3
- **Integrated**: Amazon S3 is deeply integrated with other AWS services to make it easier to build solutions that use a range of AWS services
- **Easy to manage**: Amazon S3 Storage Management features allow you to take a data-driven approach to storage optimization, data security, and management efficiency. These enterprise-class capabilities give you data about your data, so you can manage your storage based on that personalized metadata.

---

### What is AWS EC2?

**Answer**: EC2 stands for Amazon Elastic Compute Cloud. It is a web service that provides secure, resizable compute capacity in the cloud. It is designed to make web-scale computing easier for developers.

---

### What is a region?

**Answer**: A Region is a physical location in the world where we have multiple Availability Zones (AZs).

---

### What is an Availability Zone?

**Answer**: AZs consist of one or more discrete data centers, each with redundant power, networking, and connectivity, housed in separate facilities.

---

### What is an Edge Location?

**Answer**: Edge Locations are endpoints for AWS which are used for caching content. There are many more Edge Locations than Regions. Currently, there are 600+ Edge Locations.

---

### What is the difference between a region, an Availability Zone, and an Edge Location?

**Answer**:
- A region is a physical location in the world which consists of two or more Availability Zones.
- An AZ is one or more discrete data centers, each with redundant power, networking, and connectivity, housed in separate facilities.
- Edge locations are endpoints for AWS which are used for caching content.

---

### What is the root account?

**Answer**: This is the email address used to sign up for AWS. It provides unlimited access to do things in the cloud.

---

### Which permissions do new users have when created?

**Answer**: New users have NO permissions when first created.

---

### What is the difference between access keys and user/pass?

**Answer**: You cannot use the Access Key ID and Secret Key to log in to the console. You can use these to access AWS via the APIs and CLI, however.

---

### What is the size of the files on S3?

**Answer**: From 0 Bytes to 5 TB.

---

### What is the data consistency model for S3?

**Answer**:
- Strong read-after-write consistency for all PUTs (new objects and overwrites), DELETEs and LISTs, since December 2020.

---

### What are the different Tiers/Classes of storage for S3?

**Answer**:
- **S3 Standard**: 99.99% availability, 99.999999999% durability, stored redundantly across multiple devices in multiple facilities, and designed to sustain the loss of 2 facilities concurrently. No retrieval fees.
  
- **S3 - IA (Infrequently Accessed)**: For data that is accessed less frequently but requires rapid access when needed. Lower fee than S3, but you are charged a retrieval fee.

- **S3 One Zone - IA**: A lower-cost option for infrequently accessed data, but do not require the multiple AZ data resilience.

- **Glacier**: Very cheap, but used for archival only. Options: 
  - Expedited (higher fees, less retrieval time -- within minutes)
  - Standard (3-5 hours)
  - Bulk (5-12 hours).

---

### What are the S3 charges?

**Answer**: Charged for:
- Storage
- Requests
- Storage Management Pricing (the tags you use on your data, added on the metadata of your files)
- Data Transfer Pricing (when you transfer data from one region to another)
- Transfer Acceleration

---

### How does AWS Route 53 integrate with EC2 instances?

**Answer**: Route 53 is AWS's DNS service that can map domain names to EC2 instances' IP addresses. You can create DNS records (like A records) to point your domain or subdomain to an EC2 instance's public IP address, allowing users to access your instance using a friendly domain name.

### More questions to review:

- How do Security Groups and EC2 Instances relate?
- When to use Glacier, S3, EBS?
- You need a computer for 8 hours. You need 16GB of RAM and 2 vCPUs. Which type of an EC2 instance would you choose? What would be the price?

---

## Sources/Credits:

- [AWS Well-Architected Framework](https://d1.awsstatic.com/whitepapers/architecture/AWS_Well-Architected_Framework.pdf?did=wp_card&trk=wp_card)
- [AWS Overview](https://d1.awsstatic.com/whitepapers/aws-overview.pdf?did=wp_card&trk=wp_card)
- [AWS Cloud Adoption Framework](https://d1.awsstatic.com/whitepapers/aws_cloud_adoption_framework.pdf?did=wp_card&trk=wp_card)
- [Cloud Academy](https://cloudacademy.com/learning-paths/aws-fundamentals-1/)
- [A Cloud Guru](https://acloud.guru/)
- [AWS Pricing Overview](https://d1.awsstatic.com/whitepapers/aws_pricing_overview.pdf?did=wp_card&trk=wp_card)
- [AWS DevOps](https://d1.awsstatic.com/whitepapers/AWS_DevOps.pdf?did=wp_card&trk=wp_card)
- [AWS Security Best Practices](https://d1.awsstatic.com/whitepapers/Security/AWS_Security_Best_Practices.pdf?did=wp_card&trk=wp_card)
- [AWS Storage Services Whitepaper](https://d1.awsstatic.com/whitepapers/AWS%20Storage%20Services%20Whitepaper-v9.pdf?did=wp_card&trk=wp_card)
- [AWS Getting Started Use Cases](https://aws.amazon.com/getting-started/use-cases/?awsf.getting-started-use-case=use-case%23big-data-analytics&e=gs&p=gsrc_control&sc_ichannel=so&sc_icategory=abtest&sc_iname=awswt-7&sc_iurl=gsrc&sc_iversion=a-use-case-bd-analytics)
- [EC2 Instances Info](https://ec2instances.info/)
- [AWS Services Overview](https://medium.com/@ashanpriyadarshana/aws-services-overview-8432cb578227)
- [Business News Daily on AWS Training Resources](https://www.businessnewsdaily.com/10772-aws-training-resources.html)
- [AWS Case Studies: Vodafone](https://aws.amazon.com/solutions/case-studies/vodafone/)
- [AWS Case Studies: Siemens](https://aws.amazon.com/solutions/case-studies/siemens/)
- [AWS Case Studies: Atlassian](https://aws.amazon.com/solutions/case-studies/atlassian/)
- [Pros and Cons of Cloud Computing](https://www.smallbusinesscomputing.com/biztools/the-pros-and-cons-of-cloud-computing.html)
- [Cloud Computing Explained](https://www.lifewire.com/cloud-computing-explained-2373125)
- [Pros and Cons of Cloud Computing](https://www.linkedin.com/pulse/11-pros-cons-cloud-computing-everyone-should-know-umesh-singh/)
- [AWS Route 53](https://d1.awsstatic.com/events/Summits/reinvent2022/NET206_Amazon-Route-53-Whats-in-a-domain-name-A-lot!.pdf)