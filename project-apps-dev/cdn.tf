data "aws_acm_certificate" "geeks_academy" {
  domain   = "*.geeks.academy"
  statuses = ["ISSUED"]
  provider = aws.virginia
}

data "aws_cloudfront_origin_request_policy" "all_viewers" {
  name = "Managed-AllViewer"
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_origin_access_identity" "structure" {
  comment = "Origin Access Identity for structure frontend"
}

resource "aws_cloudfront_distribution" "structure" {
  origin {
    domain_name = module.S3.structure_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.structure.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "structure frontend"
  default_root_object = "index.html"

  aliases = ["structure.geeks.academy"]

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }
  
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = local.s3_origin_id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewers.id
    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_optimized.id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern             = "admin"
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = local.s3_origin_id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewers.id
    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_optimized.id

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }


  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    owner        = "bwieckow"
    "Managed by" = "Terraform"
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.geeks_academy.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019" 
  }
}
