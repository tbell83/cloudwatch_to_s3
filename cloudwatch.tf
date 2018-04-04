resource "aws_cloudwatch_log_subscription_filter" "subscription_filter" {
  count = "${length(var.logs)}"

  name            = "${var.mod_prefix}_cloudwatch_logfilter_${count.index}"
  role_arn        = "${aws_iam_role.cloudwatch_to_firehose.arn}"
  log_group_name  = "${element(var.logs[count.index], 0)}"
  filter_pattern  = "${element(var.logs[count.index], 1)}"
  destination_arn = "${aws_kinesis_firehose_delivery_stream.cloudwatch_to_s3_stream.*.arn[count.index]}"
}
