resource "aws_iam_role" "firehose_to_s3" {
  count              = "${var.mod_count == "0" ? 0 : 1}"
  name               = "${var.name}_firehose_to_s3"
  assume_role_policy = "${join("", data.aws_iam_policy_document.firehose_assume_role.*.json)}"
}

resource "aws_iam_policy" "firehose_s3_access" {
  count  = "${var.mod_count == "0" ? 0 : 1}"
  name   = "${var.name}_firehose_s3_access"
  policy = "${join("", data.aws_iam_policy_document.firehose_s3_access.*.json)}"
}

data "aws_iam_policy_document" "firehose_assume_role" {
  count = "${var.mod_count == "0" ? 0 : 1}"

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["firehose.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "firehose_s3_access" {
  count = "${var.mod_count == "0" ? 0 : 1}"

  statement {
    sid = "FirehoseS3LogBucketAccess"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      "${var.target_bucket_arn == "0" ? "${join(",", aws_s3_bucket.cloudwatch_logging_bucket.*.id)}" : "${var.target_bucket_arn}"}",
      "${var.target_bucket_arn == "0" ? "${join(",", aws_s3_bucket.cloudwatch_logging_bucket.*.id)}" : "${var.target_bucket_arn}"}/*",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_s3_access-firehose_to_s3" {
  count      = "${var.mod_count == "0" ? 0 : 1}"
  role       = "${join("", aws_iam_role.firehose_to_s3.*.name)}"
  policy_arn = "${join("", aws_iam_policy.firehose_s3_access.*.arn)}"
}

resource "aws_iam_role" "cloudwatch_to_firehose" {
  count              = "${var.mod_count == "0" ? 0 : 1}"
  name               = "${var.name}_cloudwatch_to_firehose"
  assume_role_policy = "${join("", data.aws_iam_policy_document.cloudwatch_assume_role.*.json)}"
}

data "aws_iam_policy_document" "cloudwatch_assume_role" {
  count = "${var.mod_count == "0" ? 0 : 1}"

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_policy" "firehose_access" {
  count  = "${var.mod_count == "0" ? 0 : 1}"
  name   = "${var.name}_firehose_access"
  policy = "${join("", data.aws_iam_policy_document.firehose_access.*.json)}"
}

data "aws_iam_policy_document" "firehose_access" {
  count = "${var.mod_count == "0" ? 0 : 1}"

  statement {
    sid       = "FirehoseAccess"
    actions   = ["firehose:*"]
    resources = "${aws_kinesis_firehose_delivery_stream.cloudwatch_to_s3_stream.*.arn}"
  }

  statement {
    sid       = "Passrole"
    actions   = ["iam:PassRole"]
    resources = ["${join("", aws_iam_role.cloudwatch_to_firehose.*.arn)}"]
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_to_firehose-firehose_access" {
  count      = "${var.mod_count == "0" ? 0 : 1}"
  role       = "${join("", aws_iam_role.cloudwatch_to_firehose.*.name)}"
  policy_arn = "${join("", aws_iam_policy.firehose_access.*.arn)}"
}
