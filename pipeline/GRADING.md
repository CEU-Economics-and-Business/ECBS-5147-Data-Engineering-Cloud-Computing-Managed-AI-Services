# Wikipedia Views Pipeline - Grading Criteria

**Total Points: 30**

---

## Part 1: Notebook (8 points)

| Points | Requirement |
|--------|-------------|
| 1 | `extract_views.ipynb` exists |
| 2 | Notebook fetches data from Wikipedia Page Views API |
| 2 | Notebook transforms data to JSON Lines with required fields (`title`, `views`, `rank`, `date`, `retrieved_at`) |
| 2 | Notebook uploads data to S3 at `raw-views/raw-views-YYYY-MM-DD.json` |
| 1 | At least 3 data files uploaded (notebook executed for 3 different dates) |

---

## Part 2: SQL Files (6 points)

| Points | Requirement |
|--------|-------------|
| 1 | `4_raw_views.sql` exists (correct filename) |
| 2 | `4_raw_views.sql` contains valid `CREATE EXTERNAL TABLE raw_views` with correct columns and JSON SerDe |
| 1 | `5_views_view.sql` exists (correct filename) |
| 2 | `5_views_view.sql` contains valid `CREATE VIEW views` with `ORDER BY date ASC, rank ASC` |

---

## Part 3: Lambda Function (10 points)

| Points | Requirement |
|--------|-------------|
| 1 | `lambda_extract_views.py` exists (as .py file, not notebook) |
| 2 | Lambda has `lambda_handler(event, context)` function |
| 2 | Lambda fetches from Wikipedia API and uploads to S3 |
| 1 | Lambda handles optional `date` parameter from event |
| 1 | Lambda defaults to 21 days ago when no date provided |
| 1 | Lambda deployed with correct name `WikiViewsLambda<Username>` |
| 1 | Lambda uses Python 3.13 runtime with AWSSDKPandas layer |
| 1 | Lambda timeout set to 30+ seconds |

---

## Part 4: EventBridge Schedule (4 points)

| Points | Requirement |
|--------|-------------|
| 2 | Schedule exists with correct name `WikiViewsScheduler<Username>` |
| 1 | Cron expression is `10 0 * * ? *` (daily at 0:10 UTC) |
| 1 | Schedule targets the correct Lambda function |

---

## General (2 points)

| Points | Requirement |
|--------|-------------|
| 1 | Consistent username across all resources (bucket, database, Lambda, EventBridge) |
| 1 | All files in `/homework` folder (not root or other folders) |

