resource "random_string" "suffix" {
  length    = 6
  min_lower = 6
  special   = false
}


####### CLOUDFRONT ########

resource "aws_cloudfront_distribution" "cloudfrontdistribution" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "aircall"
  default_root_object = "/index.html"
  price_class         = "PriceClass_100"
  aliases             = []
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["DE"]
    }
  }
  ######## ORIGINS #########

  origin {
    domain_name = data.terraform_remote_state.s3bucket[0].outputs.bucket_regional_domain_name
    origin_id   = "front"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${data.terraform_remote_state.s3bucket[0].outputs.oai_id}"
    }
  }
  origin {
    domain_name = split("/", trim(data.terraform_remote_state.apigwcomp[0].outputs.invoke_url, "https://"))[0]
    origin_id   = "images_no_auth"
    origin_path = "/main"
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2", "TLSv1.1"]
    }
  }

  origin {
    domain_name = split("/", trim(data.terraform_remote_state.apigwcomp[0].outputs.invoke_url, "https://"))[0]
    origin_id   = "images_auth"
    origin_path = "/main"
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2", "TLSv1.1"]
    }
  }

  ############# BEHAIVOURS ############
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "front"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  ordered_cache_behavior {
    path_pattern     = "/image"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "images_no_auth"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "/auth"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "images_auth"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  web_acl_id = data.terraform_remote_state.waf[0].outputs.id

}


############ MONITORING ###########

