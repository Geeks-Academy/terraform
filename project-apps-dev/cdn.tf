data "aws_acm_certificate" "geeks_academy" {
  domain   = "*.geeks.academy"
  statuses = ["ISSUED"]
  provider = aws.virginia
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

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

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

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "sandbox"
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.geeks_academy.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019" 
  }
}
