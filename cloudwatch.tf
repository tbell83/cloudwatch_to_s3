resource "aws_cloudwatch_log_subscription_filter" "subscription_filter" {
  count = var.mod_count == "0" ? 0 : length(var.logs)

  name            = "${var.name}_cloudwatch_logfilter_${element(var.logs[count.index], 0)}"
  role_arn        = aws_iam_role.cloudwatch_to_firehose[0].arn
  log_group_name  = element(var.logs[count.index], 0)
  filter_pattern  = element(var.logs[count.index], 1)
  destination_arn = aws_kinesis_firehose_delivery_stream.cloudwatch_to_s3_stream[count.index].arn
  distribution    = var.subscription_filter_distribution
}

