data "aws_acm_certificate" "geeks_academy" {
  domain   = "*.geeks.academy"
  statuses = ["ISSUED"]
}

resource "aws_cloudfront_origin_access_identity" "geeks_academy" {
  comment = "Geeks Academy Access ID"
}

resource "aws_cloudfront_distribution" "structure_frontend" {
  origin {
    domain_name = module.S3.structure_frontend_domain_name
    origin_id   = "S3-structure_frontend.geeks.academy"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.geeks_academy.cloudfront_access_identity_path
    }
  }

  enabled             = true
  aliases = ["*.geeks.academy", "structure.geeks.academy"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-structure_frontend.geeks.academy"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.geeks_academy.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
    cloudfront_default_certificate = false
  }
}
