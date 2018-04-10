
This module creates the AWS infrastructure required to epxort Cloudwatch log events to an S3 target.

## Created Resources
- A number of `aws_cloudwatch_log_subscription_filter` resources matching the length of the variable `logs`
- A number of `aws_kinesis_firehose_delivery_stream` resources, one for each `aws_cloudwatch_log_subscription_filter`
- An `aws_iam_role` for firehose to access S3
- A corresponding `aws_iam_policy` for the firehose to s3 role
- An `aws_iam_role` for cloudwatch to access firehose
- A corresponding `aws_iam_policy` for the cloudwatch to firehose role
- If no bucket ARN is passed for `target_bucket_arn` an `aws_s3_bucket` will be created with a bucket policy explicitly denying all users except the firehose_to_s3 role and any unique_ids defined in `s3_access_uids`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| logs | Map of log group names and associated filter patterns, and the s3 prefix.  These values are used to populate the `log_group_name` and `filter_pattern` values of the `aws_cloudwatch_log_subscription_filter` as well as `prefix` value of the corresponding `aws_kinesis_firehose_delivery_stream` | map | - | yes |
| name | Prefix for module resource names | string | `cwl` | no |
| s3_access_uids | Unique IDs of users/roles granted access to S3 bucket | list | - | yes |
| tags | tags | map | `<map>` | no |
| target_bucket_arn | ARN of target bucket | string | `0` | no |
| target_bucket_prefix | Prefix for logs being sent to target bucket | string | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudwatch_to_firehose_arn | ARN of the firehose to s3 role |
| firehose_to_s3_arn | ARN of the cloudwatch to firehose role |

