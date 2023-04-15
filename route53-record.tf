resource "aws_route53_record" "A" {
  for_each = var.alternate_domain_names != [] ? toset(var.alternate_domain_names) : []

  zone_id = var.hosted_zone_id
  name    = each.key
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.default.domain_name
    zone_id                = aws_cloudfront_distribution.default.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "ipv6" {
  for_each = var.ipv6_enabled ? toset(var.alternate_domain_names) != [] ? toset(var.alternate_domain_names) : [] : []

  zone_id = var.hosted_zone_id
  name    = each.key
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.default.domain_name
    zone_id                = aws_cloudfront_distribution.default.hosted_zone_id
    evaluate_target_health = true
  }
}
