#----
# LOG BUCKET
#----

locals {
  create_cloudfront_log_bucket      = var.enable_cloudfront_logging && var.custom_cloudfront_log_bucket_domain_name != null
  cloudfront_log_bucket_domain_name = var.custom_cloudfront_log_bucket_domain_name != null ? var.custom_cloudfront_log_bucket_domain_name : aws_s3_bucket.cloudfront_log[0].bucket_domain_name
}

resource "aws_s3_bucket" "cloudfront_log" {
  count = local.create_cloudfront_log_bucket ? 1 : 0

  bucket        = "${module.this.id}-cf-log"
  force_destroy = var.cloudfront_log_bucket_force_destroy

  tags = module.this.tags
}

resource "aws_s3_bucket_versioning" "cloudfront_log" {
  count = local.create_cloudfront_log_bucket ? 1 : 0

  bucket = aws_s3_bucket.cloudfront_log[0].id
  versioning_configuration {
    status = var.cloudfront_log_versioning_enabled ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudfront_log" {
  count = local.create_cloudfront_log_bucket ? 1 : 0

  bucket = aws_s3_bucket.cloudfront_log[0].id
  rule {
    bucket_key_enabled = false

    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudfront_log" {
  count = local.create_cloudfront_log_bucket ? 1 : 0

  bucket                  = aws_s3_bucket.cloudfront_log[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "cloudfront_log" {
  count = local.create_cloudfront_log_bucket ? 1 : 0

  bucket = aws_s3_bucket.cloudfront_log[0].id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "cloudfront_log" {
  count      = local.create_cloudfront_log_bucket ? 1 : 0
  depends_on = [aws_s3_bucket_ownership_controls.cloudfront_log]

  bucket = aws_s3_bucket.cloudfront_log[0].id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudfront_log" {
  count      = local.create_cloudfront_log_bucket && var.create_cloudfront_log_lifecycle ? 1 : 0
  depends_on = [aws_s3_bucket_versioning.cloudfront_log]

  bucket = aws_s3_bucket.cloudfront_log[0].id

  rule {
    id = "expiration-${var.log_expiration_days}"

    filter {
      prefix = var.cloudfront_log_prefix
    }

    status = "Enabled"

    transition {
      days          = var.cloudfront_log_glacier_transition_days
      storage_class = "GLACIER"
    }
    expiration {
      days = var.cloudfront_log_expiration_days
    }

    dynamic "noncurrent_version_transition" {
      for_each = var.cloudfront_log_versioning_enabled ? ["true"] : []

      content {
        noncurrent_days = var.cloudfront_log_glacier_transition_days
        storage_class   = "GLACIER"
      }
    }
    dynamic "noncurrent_version_expiration" {
      for_each = var.cloudfront_log_versioning_enabled ? ["true"] : []

      content {
        noncurrent_days = var.cloudfront_log_expiration_days
      }
    }
  }
}
