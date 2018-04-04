output "firehose_to_s3_arn" {
  value = "${aws_iam_role.firehose_to_s3.arn}"
}

output "cloudwatch_to_firehose_arn" {
  value = "${aws_iam_role.cloudwatch_to_firehose.arn}"
}
