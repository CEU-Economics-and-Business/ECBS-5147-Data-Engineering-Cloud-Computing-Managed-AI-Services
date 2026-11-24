# **Syllabus**

<div style="background-color:black; color:lightblue; padding:10px;">
  Data Engineering 1: Cloud Computing and Managed AI Services
</div>

# **Getting started**

**Codespaces:** on GitHub, click _Code_ → _Codespaces_ → _Create codespace_. Everything is preinstalled.

**Local:** install [uv](https://docs.astral.sh/uv/getting-started/installation/), then:

```
git clone https://github.com/CEU-Economics-and-Business/ECBS-5147-Data-Engineering-Cloud-Computing-Managed-AI-Services.git
cd ECBS-5147-Data-Engineering-Cloud-Computing-Managed-AI-Services
uv sync
```

Open the notebooks in VS Code and pick the `.venv` kernel (or run `uv run jupyter lab`).

**AWS credentials (both):** run `aws configure` (locally, `uv run aws configure`; `uv sync` installs the AWS CLI), paste your access key ID and secret access key, and set the default region to `eu-west-1`. Never put your keys in code or commit them to Git.

# **Prerequisites**

- Python programming
- SQL Knowledge
- Linux command-line knowledge

# **Course description**

This is a technology-focused course on cloud computing systems. Current Data Analytics Architectures often work with an amount of data that cannot be fit on a single computer. Even companies that work with reasonably small datasets are expecting rapid growth, so they prefer to use data analytics solutions that are easy to distribute and scale when needed. In this course you will get an overview and hands-on experience with basic cloud technologies as well as Serverless solutions in the cloud. You will see how cloud computing can help you quickly iterate and scale your data analytics infrastructure and how it can help you reduce operational costs.

# **Course schedule and materials for each session**

* Basics of Internet. TCP/IP, Servers, Ports, Firewalls
* Basics of Cloud Computing using Amazon Web Services (AWS): Storage and Virtual Machines
* Serverless solutions in the cloud. Using AWS programatically
* The concept of the Data Lake. Amazon Athena. Building an end-to-end data pipeline.

# **Contact**

| Instructor       | Teaching Assistant |
|------------------|--------------------|
|  Zoltan C. Toth  |    Naida Dzigal    |
|  TothZ@ceu.edu.  |    dzigaln@ceu.edu |
