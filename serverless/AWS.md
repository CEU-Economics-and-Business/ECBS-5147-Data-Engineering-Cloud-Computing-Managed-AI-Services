# AWS SDK Setup steps

## Installation
In the Codespace everything is preinstalled, you can skip this step.

Locally, run this in the repo root. It installs the AWS CLI (`awscli`), boto3, beautifulsoup4 and all other course dependencies into `.venv`:
```
uv sync
```

## CLI
Configure the AWS CLI:
```
uv run aws configure
```
(In the Codespace, or with the virtualenv activated via `source .venv/bin/activate`, plain `aws configure` works too.)

Set `eu-west-1` for the default region.

Your credentials will be stored in `~/.aws/credentials`

## BOTO3 - The AWS Python SDK

boto3 picks up the credentials from `~/.aws/credentials` automatically, no extra setup needed.

Rekognition examples:
https://docs.aws.amazon.com/code-library/latest/ug/python_3_rekognition_code_examples.html


A great deliverable from the past:
https://cosmin-ticu.medium.com/aws-for-political-analysis-2020-romanian-parliamentary-elections-8907f2f52e5a

