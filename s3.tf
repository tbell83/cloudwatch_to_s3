resource "aws_s3_bucket" "cloudwatch_logging_bucket" {
  count  = var.mod_count == "0" ? 0 : var.target_bucket_arn != "0" ? 0 : 1
  bucket = "${var.name}_cloudwatch_logging_bucket"
  tags   = var.tags
}

resource "aws_s3_bucket_policy" "cloudwatch_logging_bucket" {
  count  = var.mod_count == "0" ? 0 : var.target_bucket_arn != "0" ? 0 : 1
  bucket = aws_s3_bucket.cloudwatch_logging_bucket[0].id
  policy = data.aws_iam_policy_document.cloudwatch_logging_bucket[0].json
}

data "aws_iam_policy_document" "cloudwatch_logging_bucket" {
  count = var.mod_count == "0" ? 0 : var.target_bucket_arn != "0" ? 0 : 1

  statement {
    sid     = "DefaultDeny"
    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.cloudwatch_logging_bucket[0].id,
      "${aws_s3_bucket.cloudwatch_logging_bucket[0].id}/*",
    ]

    condition {
      test     = "StringNotLike"
      variable = "aws:userId"

      # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
      # force an interpolation expression to be interpreted as a list by wrapping it
      # in an extra set of list brackets. That form was supported for compatibilty in
      # v0.11, but is no longer supported in Terraform v0.12.
      #
      # If the expression in the following list itself returns a list, remove the
      # brackets to avoid interpretation as a list of lists. If the expression
      # returns a single list item then leave it as-is and remove this TODO comment.
      values = [
        compact(
          [var.s3_access_uids, aws_iam_role.firehose_to_s3[0].unique_id],
        ),
      ]
    }
  }
}

