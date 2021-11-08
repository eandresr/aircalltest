resource "aws_cloudfront_distribution" "cloudfrontdistribution" {
  #count = module.this.enabled ? 1 : 0
  count               = 1
  enabled             = var.distribution_enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.comment
  default_root_object = var.default_root_object
  price_class         = var.price_class
  tags                = var.tags
  #dynamic "logging_config" {
  #  for_each = var.logging_enabled ? ["true"] : []
  #  content {
  #    include_cookies = var.log_include_cookies
  #    bucket          = length(var.log_bucket_fqdn) > 0 ? var.log_bucket_fqdn : module.logs.bucket_domain_name
  #    prefix          = var.log_prefix
  #  }
  #}


  ############### TENTATIVA ##################
  #vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv#

  dynamic "origin" {
    for_each = [for i in var.dynamic_s3_origin_config : {
      name          = i.domain_name
      id            = i.origin_id
      identity      = i.origin_access_identity
      path          = lookup(i, "origin_path", null)
      custom_header = lookup(i, "custom_header", null)
    }]

    content {
      domain_name = origin.value.name
      origin_id   = origin.value.id
      origin_path = origin.value.path
      dynamic "custom_header" {
        for_each = origin.value.custom_header == null ? [] : [for i in origin.value.custom_header : {
          name  = i.name
          value = i.value
        }]
        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }
      dynamic "s3_origin_config" {
        for_each = origin.value.identity == null ? [] : [origin.value.identity]
        content {
          origin_access_identity = join("", ["origin-access-identity/cloudfront/", s3_origin_config.value])
        }
      }
    }
  }

  dynamic "origin" {
    for_each = [for i in var.dynamic_custom_origin_config : {
      name                     = i.domain_name
      id                       = i.origin_id
      path                     = lookup(i, "origin_path", null)
      http_port                = i.http_port
      https_port               = i.https_port
      origin_keepalive_timeout = i.origin_keepalive_timeout
      origin_read_timeout      = i.origin_read_timeout
      origin_protocol_policy   = i.origin_protocol_policy
      origin_ssl_protocols     = i.origin_ssl_protocols
      custom_header            = lookup(i, "custom_header", null)
    }]
    content {
      domain_name = origin.value.name
      origin_id   = origin.value.id
      origin_path = origin.value.path
      dynamic "custom_header" {
        for_each = origin.value.custom_header == null ? [] : [for i in origin.value.custom_header : {
          name  = i.name
          value = i.value
        }]
        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }
      custom_origin_config {
        http_port                = origin.value.http_port
        https_port               = origin.value.https_port
        origin_keepalive_timeout = origin.value.origin_keepalive_timeout
        origin_read_timeout      = origin.value.origin_read_timeout
        origin_protocol_policy   = origin.value.origin_protocol_policy
        origin_ssl_protocols     = origin.value.origin_ssl_protocols
      }
    }
  }
  dynamic "default_cache_behavior" {
    for_each = var.dynamic_default_cache_behavior[*]

    content {
      allowed_methods  = default_cache_behavior.value.allowed_methods
      cached_methods   = default_cache_behavior.value.cached_methods
      target_origin_id = default_cache_behavior.value.target_origin_id
      compress         = lookup(default_cache_behavior.value, "compress", null)

      forwarded_values {
        query_string = default_cache_behavior.value.query_string
        cookies {
          forward = default_cache_behavior.value.cookies_forward
        }
        headers = lookup(default_cache_behavior.value, "headers", null)
      }

      dynamic "lambda_function_association" {
        iterator = lambda
        for_each = lookup(default_cache_behavior.value, "lambda_function_association", [])
        content {
          event_type   = lambda.value.event_type
          lambda_arn   = lambda.value.lambda_arn
          include_body = lookup(lambda.value, "include_body", null)
        }
      }

      viewer_protocol_policy = default_cache_behavior.value.viewer_protocol_policy
      min_ttl                = lookup(default_cache_behavior.value, "min_ttl", null)
      default_ttl            = lookup(default_cache_behavior.value, "default_ttl", null)
      max_ttl                = lookup(default_cache_behavior.value, "max_ttl", null)
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.dynamic_ordered_cache_behavior
    iterator = cache_behavior
    content {
      path_pattern     = cache_behavior.value.path_pattern
      allowed_methods  = cache_behavior.value.allowed_methods
      cached_methods   = cache_behavior.value.cached_methods
      target_origin_id = cache_behavior.value.target_origin_id
      compress         = lookup(cache_behavior.value, "compress", null)

      forwarded_values {
        query_string = cache_behavior.value.query_string
        cookies {
          forward = cache_behavior.value.cookies_forward
        }
        headers = lookup(cache_behavior.value, "headers", null)
      }

      dynamic "lambda_function_association" {
        iterator = lambda
        for_each = lookup(cache_behavior.value, "lambda_function_association", [])
        content {
          event_type   = lambda.value.event_type
          lambda_arn   = lambda.value.lambda_arn
          include_body = lookup(lambda.value, "include_body", null)
        }
      }

      viewer_protocol_policy = cache_behavior.value.viewer_protocol_policy
      min_ttl                = lookup(cache_behavior.value, "min_ttl", null)
      default_ttl            = lookup(cache_behavior.value, "default_ttl", null)
      max_ttl                = lookup(cache_behavior.value, "max_ttl", null)
    }
  }

  ######  https://github.com/jmgreg31/terraform-aws-cloudfront  #######
  #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#
  ############################################

  aliases = var.aliases

  dynamic "custom_error_response" {
    for_each = var.custom_error_response
    content {
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", null)
      error_code            = custom_error_response.value.error_code
      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
    }
  }


  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = var.viewer_minimum_protocol_version
    cloudfront_default_certificate = var.acm_certificate_arn == "" ? true : false
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache

    content {
      path_pattern = ordered_cache_behavior.value.path_pattern

      allowed_methods  = ordered_cache_behavior.value.allowed_methods
      cached_methods   = ordered_cache_behavior.value.cached_methods
      target_origin_id = ordered_cache_behavior.value.target_origin_id == "" ? module.this.id : ordered_cache_behavior.value.target_origin_id
      compress         = ordered_cache_behavior.value.compress
      trusted_signers  = var.trusted_signers

      forwarded_values {
        query_string = ordered_cache_behavior.value.forward_query_string
        headers      = ordered_cache_behavior.value.forward_header_values

        cookies {
          forward = ordered_cache_behavior.value.forward_cookies
        }
      }

      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      default_ttl            = ordered_cache_behavior.value.default_ttl
      min_ttl                = ordered_cache_behavior.value.min_ttl
      max_ttl                = ordered_cache_behavior.value.max_ttl

      dynamic "lambda_function_association" {
        for_each = ordered_cache_behavior.value.lambda_function_association
        content {
          event_type   = lambda_function_association.value.event_type
          include_body = lookup(lambda_function_association.value, "include_body", null)
          lambda_arn   = lambda_function_association.value.lambda_arn
        }
      }
    }
  }

  web_acl_id = var.web_acl_id

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  #tags = module.this.tags
}
data "aws_region" "current" {}
