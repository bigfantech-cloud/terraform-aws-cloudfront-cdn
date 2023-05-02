resource "aws_cloudfront_distribution" "default" {

  origin {
    domain_name = var.origin_domain_name
    origin_id   = module.this.id

    custom_origin_config {
      http_port                = var.origin_http_port
      https_port               = var.origin_https_port
      origin_protocol_policy   = var.origin_protocol_policy
      origin_ssl_protocols     = var.origin_ssl_protocols
      origin_keepalive_timeout = 60
      origin_read_timeout      = 60
    }

    dynamic "origin_shield" {
      for_each = var.origin_shield_region != "" ? [true] : []

      content {
        enabled              = true
        origin_shield_region = var.origin_shield_region
      }
    }

    dynamic "s3_origin_config" {
      for_each = var.s3_origin_access_identity != null ? [true] : []
      content {
        origin_access_identity = var.s3_origin_access_identity
      }
    }
  }

  enabled             = var.enable_distribution
  is_ipv6_enabled     = var.ipv6_enabled
  comment             = var.description
  default_root_object = var.default_root_object
  aliases             = var.alternate_domain_names

  dynamic "logging_config" {
    for_each = var.log_bucket_domain_name != null ? ["true"] : []

    content {
      include_cookies = false
      bucket          = var.log_bucket_domain_name
      prefix          = try(var.log_prefix, "/")
    }
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_response

    content {
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", null)
      error_code            = custom_error_response.value.error_code
      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
    }
  }

  default_cache_behavior {
    allowed_methods             = lookup(var.default_cache_behavior, allowed_methods, ["GET", "HEAD"])
    cached_methods              = lookup(var.default_cache_behavior, cached_methods, ["GET", "HEAD"])
    target_origin_id            = lookup(var.default_cache_behavior, target_origin_id, module.this.id)
    viewer_protocol_policy      = lookup(var.default_cache_behavior, viewer_protocol_policy, "redirect-to-https")
    cache_policy_id             = lookup(var.default_cache_behavior, cache_policy_id, "4135ea2d-6df8-44a3-9df3-4b5a84be39ad")
    compress                    = lookup(var.default_cache_behavior, compress, false)
    default_ttl                 = lookup(var.default_cache_behavior, default_ttl, null)
    field_level_encryption_id   = lookup(var.default_cache_behavior, field_level_encryption_id, null)
    min_ttl                     = lookup(var.default_cache_behavior, min_ttl, null)
    max_ttl                     = lookup(var.default_cache_behavior, max_ttl, null)
    origin_request_policy_id    = lookup(var.default_cache_behavior, origin_request_policy_id, null)
    realtime_log_config_arn     = lookup(var.default_cache_behavior, realtime_log_config_arn, null)
    response_headers_policy_id  = lookup(var.default_cache_behavior, response_headers_policy_id, null)
    smooth_streaming            = lookup(var.default_cache_behavior, smooth_streaming, null)
    trusted_key_groups          = lookup(var.default_cache_behavior, trusted_key_groups, null)
    trusted_signers             = lookup(var.default_cache_behavior, trusted_signers, null)
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior

    content {
      path_pattern                = ordered_cache_behavior.value.path_pattern
      allowed_methods             = ordered_cache_behavior.value.allowed_methods
      cached_methods              = ordered_cache_behavior.value.cached_methods
      viewer_protocol_policy      = ordered_cache_behavior.value.viewer_protocol_policy
      target_origin_id            = ordered_cache_behavior.value.target_origin_id
      cache_policy_id             = lookup(ordered_cache_behavior.value, cache_policy_id, null)
      compress                    = lookup(ordered_cache_behavior.value, compress, false)
      default_ttl                 = lookup(ordered_cache_behavior.value, default_ttl, null)
      field_level_encryption_id   = lookup(ordered_cache_behavior.value, field_level_encryption_id, null)
      min_ttl                     = lookup(ordered_cache_behavior.value, min_ttl, null)
      max_ttl                     = lookup(ordered_cache_behavior.value, max_ttl, null)
      origin_request_policy_id    = lookup(ordered_cache_behavior.value, origin_request_policy_id, null)
      realtime_log_config_arn     = lookup(ordered_cache_behavior.valuer, realtime_log_config_arn, null)
      response_headers_policy_id  = lookup(ordered_cache_behavior.value, response_headers_policy_id, null)
      smooth_streaming            = lookup(ordered_cache_behavior.value, smooth_streaming, null)
      trusted_key_groups          = lookup(ordered_cache_behavior.value, trusted_key_groups, null)
      trusted_signers             = lookup(ordered_cache_behavior.value, trusted_signers, null)
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  tags = merge(
    module.this.tags,
    {
      Name = "${module.this.id}"
    }
  )

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    cloudfront_default_certificate = var.acm_certificate_arn != null ? false : true
    minimum_protocol_version       = var.certificate_minimum_protocol_version
    ssl_support_method             = var.acm_certificate_arn != null ? var.ssl_support_method : null
  }
}
