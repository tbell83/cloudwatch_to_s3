resource "aws_kinesis_firehose_delivery_stream" "cloudwatch_to_s3_stream" {
  count = "${length(var.logs)}"

  name        = "${var.mod_prefix}-cloudwatch-logging${count.index + 1}"
  destination = "extended_s3"

  extended_s3_configuration {
    prefix             = "${var.target_bucket_prefix == "0" ? "" : "${var.target_bucket_prefix}/"}${element(var.logs[count.index], 2)}/"
    role_arn           = "${aws_iam_role.cloudwatch_to_firehose.arn}"
    bucket_arn         = "${var.target_bucket_arn == "0" ? "${join(",", aws_s3_bucket.cloudwatch_logging_bucket.*.id)}" : "${var.target_bucket_arn}"}"
    compression_format = "COMPRESSED"
  }
}