output "firehose_to_s3_arn" {
  description = "ARN of the firehose to s3 role"
  value       = "${var.mod_count == "0" ? "null" : join(",", aws_iam_role.firehose_to_s3.*.arn)}"
}

output "cloudwatch_to_firehose_arn" {
  description = "ARN of the cloudwatch to firehose role"
  value       = "${var.mod_count == "0" ? "null" : join(",", aws_iam_role.cloudwatch_to_firehose.*.arn)}"
}
