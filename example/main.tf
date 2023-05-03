module "alb" {
  source  = "bigfantech-cloud/alb-ecs/aws"
  version = "a.b.c" # find latest version from https://registry.terraform.io/modules/bigfantech-cloud/ecs-alb/aws/latest

  project_name             = "abc"
  environment              = "dev"
  # ....
  # ...... other module attributes
  # ............
}
  
module "cloudfront" {
  source  = "bigfantech-cloud/cloudfront-cdn/aws"
  version = "a.b.c" # Find the latest version from https://registry.terraform.io/modules/bigfantech-cloud/cloudfront-cdn/aws/latest

  project_name = "abc"
  environment  = "dev"
  attributes   = ["adminportal"]

  origin_domain_name        = module.alb.alb_dns_name
  description               = "A CDN"
  alternate_domain_names    = ["abc.com"]
  hosted_zone_id            = "abc123defg"
  acm_certificate_arn       = "arn:::/"
  default_cache_behavior = {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    origin_request_policy_id   = aws_cloudfront_origin_request_policy.pass_host_header.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.set_cookie.id
    compress                   = true
  }
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
    cookie_behavior = "whitelist"
    cookies {
      items = ["fuze-admin-user"]
    }
  }
}

resource "aws_cloudfront_response_headers_policy" "set_cookie" {
  name    = "Response-Header-Policy"
  comment = "Respone header allow set cookie"

  custom_headers_config {
    items {
      header   = "set-cookie"
      override = false
      value    = "none"
    }
  }
}
