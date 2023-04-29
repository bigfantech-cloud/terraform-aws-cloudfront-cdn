# Purpose:

Create CloudFront CDN. And create Route53 record for each Alternate Domains provided.

## Variable Inputs:

#### REQUIRED:

```
project_name               (example: project name)

origin_domain_name:
  The DNS domain name of either the Custom Origin, or S3 bucket.

```

### OPTIONAL

```
environment                (example: dev/prod)

enable_distribution:
  Whether the distribution is enabled to accept end user requests for content. Default = true.
  default     = true

description:
  Distribution description.

alternate_domain_names
  List of alternate Domains. Route53 records will be created for each domain.

hosted_zone_id:
  Route53 hosted zone ID. Required if alternate_domain_names is specified.

origin_http_port:
  The HTTP port the custom origin listens on. Default = 80.
  default     = 80

origin_https_port:
  The HTTPS port the custom origin listens on. Default = 443.
  default     = 443

origin_protocol_policy:
  The origin protocol policy to apply to origin. One of http-only, https-only, or match-viewer. Default = https-only.
  default     = "https-only

origin_ssl_protocols:
  The SSL/TLS protocols CloudFront to use when communicating with origin over HTTPS.
  A list of one or more of SSLv3, TLSv1, TLSv1.1, and TLSv1.2.
  default     = ["TLSv1.2"]

origin_shield_region:
  The AWS Region for Origin Shield. To specify a region, use the region code, not the region name.
  example: US East (Ohio) region as us-east-2.
  CloudFront Origin Shield adds an additional layer in the CloudFront caching infrastructure that helps to minimize origin’s load,
  improve its availability, and reduce its operating costs.

default_root_object:
  The object that you want CloudFront to return (example: index.html) when an end user requests the root URL.
  Default = null.

s3_origin_access_identity:
  The CloudFront origin access identity to associate with the S3 origin. Applicable only if Origin is S3 bucket.

ipv6_enabled:
  Is ipv6 enabled for the Distribution. AAA Route53 record will be created if set 'true'.
  Default = false.

custom_error_response:
  List of map with Custom Error Response configurations.
  type = list(object({
    error_caching_min_ttl = string
    error_code            = string
    response_code         = string
    response_page_path    = string
  }))
  default = []


#----------
# DEFAULT CACHE BEHAVIOUR
#----------

default_cache_compress:
  Whether CloudFront to automatically compress content for web requests. Default = ture.

default_cache_allowed_method:
  List of HTTP methods CloudFront processes and forwards to the Origin.
  Default = ["GET", "HEAD"]

default_cached_methods:
  Controls whether CloudFront caches the response to requests using the specified HTTP methods.
  Default = ["GET", "HEAD"]

default_cache_viewer_protocol_policy:
  Protocol that users can use to access the files in the origin.
  One of allow-all, https-only, or redirect-to-https.
  Default = "redirect-to-https.

default_cache_policy_id:
  Cache Policy that is attached to the cache behavior. Cache Policy can be created with resource 'aws_cloudfront_cache_policy'.
  Default = CachingDisabled

origin_request_policy_id:
  Origin request policy ID. Origin request policy can be created using 'aws_cloudfront_origin_request_policy' Terraform resource.
  Default = null.

default_cache_origin_request_policy_id:
  Origin request policy ID. Origin request policy can be created using 'aws_cloudfront_origin_request_policy' Terraform resource.
  Default = null.

default_cache_response_headers_policy_id:
  Response Header Policy that is attached to the behavior. Response Header Policy can be created with resource 'aws_cloudfront_response_headers_policy'.
  Terraform resource.
  Default = null.

#----------
# ORDERED CACHE BEHAVIOUR
#----------

ordered_cache_behavior:
  List of map for Ordered Cache Behavior configuration.
  type = list(object({
    path_pattern             = string
    compress                 = bool
    allowed_methods          = list(string)
    cached_methods           = list(string)
    viewer_protocol_policy   = string
    cache_policy_id          = string
    origin_request_policy_id = string
    target_origin_id         = string
  }))

  default = [].

#----
# GEO RESTRICTION
#----

geo_restriction_type:
  Restriction methods. example: none, whitelist, or blacklist. Default = none.

geo_restriction_locations:
    List of location to apply Geo Restriction.
    Country codes are ALPHA-2 code found on https://www.iso.org/obp/ui/#search
    Default =[].

#----
# LOG
#----

log_bucket:
  Name of the S3 bucket to save logs. Passing bucket name will enable logging.

log_prefix:
  Log Prefix"

#-----
# CERTIFICARTE
#-----

acm_certificate_arn:
  ACM certificate ARN. Required if alternate_domain_names is specified.

certificate_minimum_protocol_version:
  The minimum version of the SSL protocol for CloudFront to use for HTTPS connections. Default = TLSv1.2_2021.

ssl_support_method:
  SSL support method. Default= sni-only.

```

## Majot resources created:

- CloudFront Distribution.
- Route53 records (respect to Alternate Domains)

# Steps to create the resources

1. Call the module from your tf code.
2. Specify the variable inputs.

Example:

```
provider "aws" {
  region = "us-east-1"
}

module "cloudfront" {
  source      = "bigfantech-cloud/cloudfront-cdn/aws"
  version     = "1.0.0"

  project_name  = "abc"
  environment   = "dev"
  attributes    = ["adminportal"]

  origin_domain_name       = "origin-domain.com"
  description              = "DEV AdminPortal CDN"
  origin_request_policy_id = aws_cloudfront_origin_request_policy.pass_host_header.id

  alternate_domain_names    = ["test.com"]
  hosted_zone_id            = "ABCD1234EFG5678"
  acm_certificate_arn       = "arn:aws:acm:"
  geo_restriction_type      = "whitelist"
  geo_restriction_locations = ["IN"]

}

resource "aws_cloudfront_origin_request_policy" "pass_host_header" {
  name    = "AllowHostHeader"
  comment = "Passes host header"

  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["host"]
    }
  }
  query_strings_config {
    query_string_behavior = "none"
  }

  cookies_config {
    cookie_behavior = "none"
  }
}

```

3. Apply: From terminal run following commands.

```
terraform init
```

```
terraform plan
```

```
terraform apply
```

!! You have successfully created CloudFront CDN as per your specification !!

---

##OUTPUTS

```
- cloudfront_distribution_id
    CloudFront distribution ID

- cloudfront_distribution_arn
    CloudFront distribution ARN

- cloudfront_distribution_domain_name
    CloudFront distribution domain name

- cloudfront_distribution_hosted_zone_id
    CloudFront distribution hosted zone ID
```
