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
    for_each = var.log_bucket != null ? ["true"] : []

    content {
      include_cookies = false
      bucket          = var.log_bucket
      prefix          = var.log_prefix
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
    compress                    = var.default_cache_compress
    allowed_methods             = var.default_cache_allowed_method
    cached_methods              = var.default_cached_methods
    viewer_protocol_policy      = var.default_cache_viewer_protocol_policy
    cache_policy_id             = var.default_cache_policy_id
    origin_request_policy_id    = var.default_cache_origin_request_policy_id
    response_headers_policy_id  = var.default_cache_response_headers_policy_id
    target_origin_id            = module.this.id
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior

    content {
      path_pattern                = ordered_cache_behavior.value.path_pattern
      compress                    = ordered_cache_behavior.value.compress
      allowed_methods             = ordered_cache_behavior.value.allowed_methods
      cached_methods              = ordered_cache_behavior.value.cached_methods
      viewer_protocol_policy      = ordered_cache_behavior.value.viewer_protocol_policy
      cache_policy_id             = ordered_cache_behavior.value.cache_policy_id
      origin_request_policy_id    = ordered_cache_behavior.value.origin_request_policy_id
      response_headers_policy_id  = ordered_cache_behavior.response_headers_policy_id
      target_origin_id            = ordered_cache_behavior.value.target_origin_id
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
