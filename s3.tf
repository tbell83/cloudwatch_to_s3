resource "aws_s3_bucket" "cloudwatch_logging_bucket" {
  count  = "${var.count == "0" ? 0 : var.target_bucket_arn != "0" ? 0 : 1}"
  bucket = "${var.mod_prefix}_cloudwatch_logging_bucket"
  tags   = "${var.tags}"
}

resource "aws_s3_bucket_policy" "cloudwatch_logging_bucket" {
  count  = "${var.count == "0" ? 0 : var.target_bucket_arn != "0" ? 0 : 1}"
  bucket = "${aws_s3_bucket.cloudwatch_logging_bucket.id}"
  policy = "${data.aws_iam_policy_document.cloudwatch_logging_bucket.json}"
}

data "aws_iam_policy_document" "cloudwatch_logging_bucket" {
  count = "${var.count == "0" ? 0 : var.target_bucket_arn != "0" ? 0 : 1}"

  statement {
    sid     = "DefaultDeny"
    actions = ["s3:*"]

    resources = [
      "${aws_s3_bucket.cloudwatch_logging_bucket.id}",
      "${aws_s3_bucket.cloudwatch_logging_bucket.id}/*",
    ]

    condition {
      test     = "StringNotLike"
      variable = "aws:userId"

      values = ["${compact(list(
        "${var.s3_access_uids}",
        "${aws_iam_role.firehose_to_s3.unique_id}"
      ))}"]
    }
  }
}
