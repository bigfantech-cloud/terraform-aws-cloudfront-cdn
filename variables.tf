variable "enable_distribution" {
  description = "Whether the distribution is enabled to accept end user requests for content. Default = true"
  type        = bool
  default     = true
}

variable "description" {
  description = "Distribution description"
  type        = string
  default     = ""
}

variable "origin_domain_name" {
  description = "The DNS domain name of either the Custom Origin, or S3 bucket."
  type        = string
}

variable "alternate_domain_names" {
  description = "List of alternate Domains. Route53 records will be created for each domain."
  type        = list(string)
  default     = []
}

variable "origin_http_port" {
  description = "The HTTP port the custom origin listens on. Default = 80"
  type        = number
  default     = 80
}

variable "origin_https_port" {
  description = "The HTTPS port the custom origin listens on. Default = 443"
  type        = number
  default     = 443
}

variable "origin_protocol_policy" {
  description = "The origin protocol policy to apply to origin. One of http-only, https-only, or match-viewer. Default = https-only"
  type        = string
  default     = "https-only"

}

variable "origin_ssl_protocols" {
  description = <<-EOF
  The SSL/TLS protocols CloudFront to use when communicating with origin over HTTPS.
  A list of one or more of SSLv3, TLSv1, TLSv1.1, and TLSv1.2.
  Default = ["TLSv1.2"]
  EOF
  default     = ["TLSv1.2"]
}

variable "origin_shield_region" {
  description = <<-EOF
  The AWS Region for Origin Shield. To specify a region, use the region code, not the region name.
  example: US East (Ohio) region as us-east-2.
  CloudFront Origin Shield adds an additional layer in the CloudFront caching infrastructure that helps to minimize origin’s load,
  improve its availability, and reduce its operating costs.
  EOF
  type        = string
  default     = ""
}

variable "default_root_object" {
  description = "The object that you want CloudFront to return (example: index.html) when an end user requests the root URL. Default = null"
  type        = string
  default     = null
}

variable "s3_origin_access_identity" {
  description = "The CloudFront origin access identity to associate with the S3 origin. Applicable only if Origin is S3 bucket."
  type        = string
  default     = null
}

variable "ipv6_enabled" {
  description = "Is ipv6 enabled for the Distribution. AAA Route53 record will be created if set 'true'. Default = false"
  type        = bool
  default     = false
}

variable "custom_error_response" {
  description = "List of map with Custom Error Response configurations. Default = []"
  type = list(object({
    error_caching_min_ttl = string
    error_code            = string
    response_code         = string
    response_page_path    = string
  }))

  default = []
}

#----------
# DEFAULT CACHE BEHAVIOUR
#----------

variable "default_cache_compress" {
  description = "Whether CloudFront to automatically compress content for web requests. Default = ture"
  type        = bool
  default     = true
}

variable "default_cache_allowed_method" {
  description = <<-EOF
    List of HTTP methods CloudFront processes and forwards to the Origin.
    Default = ["GET", "HEAD"]
    EOF
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "default_cached_methods" {
  description = <<-EOF
    Controls whether CloudFront caches the response to requests using the specified HTTP methods.
    Default = ["GET", "HEAD"]
    EOF

  type    = list(string)
  default = ["GET", "HEAD"]
}

variable "default_cache_viewer_protocol_policy" {
  description = <<-EOF
    Protocol that users can use to access the files in the origin. 
    One of allow-all, https-only, or redirect-to-https.
    Default = "redirect-to-https"
    EOF

  type    = string
  default = "redirect-to-https"
}

variable "default_cache_policy_id" {
  description = <<-EOF
    Cache Policy that is attached to the cache behavior. Cache Policy can be created with resource 'aws_cloudfront_cache_policy'.
    Default = CachingDisabled
    EOF

  type    = string
  default = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
}

variable "default_cache_origin_request_policy_id" {
  description = <<-EOF
    Origin Request Policy that is attached to the behavior. Origin Request Policy can be created with resource 'aws_cloudfront_origin_request_policy'.
    Default = null
    EOF

  type    = string
  default = null
}

variable "default_cache_response_headers_policy_id" {
  description = <<-EOF
    Response Header Policy that is attached to the behavior. Response Header Policy can be created with resource 'aws_cloudfront_response_headers_policy'.
    Default = null
    EOF

  type    = string
  default = null
}

#----------
# ORDERED CACHE BEHAVIOUR
#----------

variable "ordered_cache_behavior" {
  description = "List of map for Ordered Cache Behavior configuration"
  type = list(object({
    path_pattern               = string
    compress                   = bool
    allowed_methods            = list(string)
    cached_methods             = list(string)
    viewer_protocol_policy     = string
    cache_policy_id            = string
    origin_request_policy_id   = string
    response_headers_policy_id = string
    target_origin_id           = string
  }))

  default = []
}

#----
# GEO RESTRICTION
#----

variable "geo_restriction_type" {
  description = "Restriction methods. example: none, whitelist, or blacklist. Default = none"
  type        = string
  default     = "none"
}

variable "geo_restriction_locations" {
  description = <<-EOF
    List of location to apply Geo Restriction.
    Country codes are ALPHA-2 code found on https://www.iso.org/obp/ui/#search
    Default =[]
    EOF
  type        = list(string)
  default     = []
}

#-----
# CERTIFICARTE
#-----

variable "acm_certificate_arn" {
  description = "ACM certificate ARN. Required if alternate_domain_names is specified."
  type        = string
  default     = null
}

variable "certificate_minimum_protocol_version" {
  description = "The minimum version of the SSL protocol for CloudFront to use for HTTPS connections. Default = TLSv1.2_2021"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "ssl_support_method" {
  description = "SSL support method. Default= sni-only"
  type        = string
  default     = "sni-only"
}


#----
# LOG
#----

variable "log_bucket" {
  description = "Name of the S3 bucket to save logs. Passing bucket name will enable logging."
  type        = string
  default     = null
}

variable "log_prefix" {
  description = "Log Prefix"
  type        = string
  default     = null
}

#----
# ROUTE53 RECORDS
#----

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID. Required if alternate_domain_names is specified."
  type        = string
  default     = null
}
