variable "mod_count" {
  description = "https://github.com/hashicorp/terraform/issues/953"
  type        = "string"
  default     = 1
}

variable "compression_method" {
  description = "valid types: [ZIP, Snappy, GZIP, UNCOMPRESSED]"
  type        = "string"
  default     = "GZIP"
}

variable "logs" {
  description = "Map of logs and associated filter patterns"
  type        = "map"
}

variable "name" {
  description = "Prefix for module resource names"
  type        = "string"
  default     = "cwl"
}

variable "s3_access_uids" {
  description = "Unique IDs of users/roles granted access to S3 bucket"
  type        = "list"
}

variable "tags" {
  description = "tags"
  type        = "map"

  default = {
    "Managed" = "Terraform"
    "Name"    = "cwl"
  }
}

variable "target_bucket_arn" {
  description = "ARN of target bucket"
  type        = "string"
  default     = "0"
}

variable "target_bucket_prefix" {
  description = "Prefix for logs being sent to target bucket"
  type        = "string"
  default     = "0"
}

variable "subscription_filter_distribution" {
  description = "The method used to distribute log data to the destination. By default log data is grouped by log stream, but the grouping can be set to random for a more even distribution. This property is only applicable when the destination is an Amazon Kinesis stream. Valid values are 'Random' and 'ByLogStream'. Defaults to 'ByLogStream'."
  type        = "string"
  default     = "ByLogStream"
}
