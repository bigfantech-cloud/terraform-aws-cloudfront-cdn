# BigFantech-Cloud

We automate your infrastructure.
You will have full control of your infrastructure, including Infrastructure as Code (IaC).

To hire, email: `bigfantech@yahoo.com`

# Purpose of this code

> Terraform module

Create CloudFront CDN. And create Route53 record for each Alternate Domains provided.

## Variables

### Required Variables

| Name                 | Description                                                               | Default |
| -------------------- | ------------------------------------------------------------------------- | ------- |
| `project_name`       |                                                                           |         |
| `origin_domain_name` | The DNS domain name of either the Custom Origin, or S3 bucket domain name |         |

### Optional Variables

| Name                                       | Description                                                                                                                                                                                                                                                                              | Type | Default                                                                                                                                                                                                                                   |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `enable_distribution`                      | Whether the distribution is enabled to accept end user requests for content                                                                                                                                                                                                             | bool  | true                                                                                                                                                                                                                                      |
| `description`                              | Distribution description                                                                                                                                                                                                                                                                | string  |                                                                                                                                                                                                                                           |
| `origin_domain_name`                       | The DNS domain name of either the Custom Origin, or S3 bucket                                                                                                                                                                                                                         | string    |                                                                                                                                                                                                                                           |
| `hosted_zone_id`                           | Route53 hosted zone ID. Required if alternate_domain_names is specified                                                                                                                                                                                                              | string     | null                                                                                                                                                                                                                                      |
| `alternate_domain_names`                   | List of alternate Domains. Route53 records will be created for each domain                                                                                                                                                                                                          | list(string)      | []                                                                                                                                                                                                                                        |
| `acm_certificate_arn`                      | ACM certificate ARN. Required if alternate_domain_names is specified                                                                                                                                                                                                                 | string     | null                                                                                                                                                                                                                                      |
| `origin_http_port`                         | The HTTP port the custom origin listens on                                                                                                                                                                                                                                       | number         | 80                                                                                                                                                                                                                                        |
| `origin_https_port`                        | The HTTPS port the custom origin listens on                                                                                                                                                                                                                                    | number           | 443                                                                                                                                                                                                                                       |
| `origin_protocol_policy`                   | The origin protocol policy to apply to origin. One of `http-only`, `https-only`, or `match-viewer`                                                                                                                                                                           | string             | https-only                                                                                                                                                                                                                                |
| `origin_ssl_protocols`                     | The SSL/TLS protocols CloudFront to use when communicating with origin over HTTPS. A list of one or more of SSLv3, TLSv1, TLSv1.1, and TLSv1.2                                                                                                                                   | list(string)         | ["TLSv1.2"]                                                                                                                                                                                                                               |
| `origin_shield_region`                     | The AWS Region for Origin Shield. To specify a region, use the region code, not the region name CloudFront Origin Shield adds an additional layer in the CloudFront caching infrastructure that helps to minimize origin’s load, improve its availability, and reduce its operating costs |                                                                                                                                                                                                                                      string |     |
| `default_root_object`                      | The object that you want CloudFront to return (example: index.html) when an end user requests the root URL                                                                                                                                                                  | string              | null                                                                                                                                                                                                                                      |
| `s3_origin_access_identity`                | The CloudFront origin access identity to associate with the S3 origin. Applicable only if Origin is S3 bucket                                                                                                                                                                      | string       | null                                                                                                                                                                                                                                      |
| `ipv6_enabled`                             | Is ipv6 enabled for the Distribution. AAA Route53 record will be created if set 'true'                                                                                                                                                                                              | bool      | false                                                                                                                                                                                                                                     |
| `custom_error_response`                    | List of map with Custom Error Response configurations `error_code`, `error_caching_min_ttl` (optional), `response_code` (optional), `response_page_path`(optional)                                                                                                                 | list(object({<br>error_code            = string<br>error_caching_min_ttl = optional(string)<br>response_code         = optional(string)<br>response_page_path    = optional(string)<br>}))       | []                                                                                                                                                                                                                                        |
| `default_cache_behavior`                   | Map of default cache configs, ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#default-cache-behavior-arguments                                                                                                             | object({<br>allowed_methods            = optional(list(string))<br>cached_methods             = optional(list(string))<br>target_origin_id           = optional(string)<br>viewer_protocol_policy     = optional(string)<br>cache_policy_id            = optional(string)<br>compress                   = optional(bool)<br>default_ttl                = optional(number)<br>field_level_encryption_id  = optional(string)<br>min_ttl                    = optional(number)<br>max_ttl                    = optional(number)<br>origin_request_policy_id   = optional(string)<br>realtime_log_config_arn    = optional(string)<br>response_headers_policy_id = optional(string)<br>smooth_streaming           = optional(bool)<br>trusted_key_groups         = optional(list(string))<br>trusted_signers            = optional(list(string))<br>})      | {<br>allowed_methods = ["GET", "HEAD"]<br>cached_methods<br> = ["GET", "HEAD"]<br> target_origin_id = `CloudFrontName`<br> viewer_protocol_policy = "redirect-to-https"<br> cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"<br>} |
| `ordered_cache_behavior`                   | List of map of Ordered Cache Behavior configuration, ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#default-cache-behavior-arguments                                                                                      | list(object({path_pattern               = string<br>allowed_methods            = optional(list(string))<br>cached_methods             = optional(list(string))<br>target_origin_id           = optional(string)<br>viewer_protocol_policy     = optional(string)<br>cache_policy_id            = optional(string)<br>compress                   = optional(bool)<br>default_ttl                = optional(number)<br>field_level_encryption_id  = optional(string)<br>min_ttl                    = optional(number)<br>max_ttl                    = optional(number)<br>origin_request_policy_id   = optional(string)<br>realtime_log_config_arn    = optional(string)<br>response_headers_policy_id = optional(string)<br>smooth_streaming           = optional(bool)<br>trusted_key_groups         = optional(list(string))<br>trusted_signers            = optional(list(string))<br>}))      | []                                                                                                                                                                                                                                        |
| `web_acl_id`|AWS WAF ARN to associate with CloudFront | string | |
| `geo_restriction_type`                     | Restriction methods. example: none, whitelist, or blacklist                                                                                                                                                                                                                       | string        | none                                                                                                                                                                                                                                      |
| `geo_restriction_locations`                | List of location to apply Geo Restriction. Country codes are ALPHA-2 code found on https://www.iso.org/obp/ui/#search                                                                                                                                                            | list(string)         | []                                                                                                                                                                                                                                        |
| `certificate_minimum_protocol_version`     | The minimum version of the SSL protocol for CloudFront to use for HTTPS connections                                                                                                                                                                                                 | string      | TLSv1.2_2021                                                                                                                                                                                                                              |
| `ssl_support_method`                       | SSL support method                                                                                                                                                                                                                                                                  | string      | sni-only                                                                                                                                                                                                                                  |
| `enable_cloudfront_logging`                | Whether to enable CloudFront logging                                                                                                                                                                                                                                                | bool      | false                                                                                                                                                                                                                                     |
| `cloudfront_log_bucket_versioning_enabled`        | Whether to enable CloudFront log bucket versioning                                                                                                                                                                                                                              | bool          | false                                                                                                                                                                                                                                     |
| `custom_cloudfront_log_bucket_domain_name` | Custom created S3 bucket domain name. A bucket will be created if `enable_cloudfront_logging` is true, and `custom_cloudfront_log_bucket_domain_name` not set                                                                                                                     | string        | null                                                                                                                                                                                                                                      |
| `cloudfront_log_prefix`                    | CloudFront log prefix                                                                                                                                                                                                                                                                | string      |                                                                                                                                                                                                                                           |
| `create_cloudfront_log_bucket_lifecycle`          | Whether to create CloudFront log bucket lifecycle                                                                                                                                                                                                                                  | bool        | true                                                                                                                                                                                                                                      |
| `cloudfront_log_glacier_transition_days`   | Number in days after which objects are transistioned to Glacier                                                                                                                                                                                                                       | number     | 90                                                                                                                                                                                                                                        |
| `cloudfront_log_expiration_days`           | Number in days after which objects are deleted                                                                                                                                                                                                                                      | number      | 180                                                                                                                                                                                                                                       |

### Example config

> Check the `example` folder in this repo

### Outputs

| Name                                     | Description                            |
| ---------------------------------------- | -------------------------------------- |
| `cloudfront_distribution_id`             | CloudFront distribution ID             |
| `cloudfront_distribution_arn`            | CloudFront distribution ARN            |
| `cloudfront_distribution_domain_name`    | CloudFront distribution domain name    |
| `cloudfront_distribution_hosted_zone_id` | CloudFront distribution hosted zone ID |
| `cloudfront_log_bucket_name`             | CloudFront log bucket name             |
