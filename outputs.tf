output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.default.id
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.default.arn
}

output "cloudfront_distribution_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.default.domain_name
}

output "cloudfront_distribution_hosted_zone_id" {
  description = "CloudFront distribution hosted zone ID"
  value       = aws_cloudfront_distribution.default.hosted_zone_id
}

output "cloudfront_log_bucket_name" {
  description = "CloudFront log bucket name"
  value       = local.create_cloudfront_log_bucket ? aws_s3_bucket.cloudfront_log[0].id : null
}
