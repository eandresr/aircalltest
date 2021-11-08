resource "random_string" "suffix" {
  length    = 6
  min_lower = 6
  special   = false
}

##### PERMISSIONS #####


####### BUCKET ########
resource "aws_s3_bucket" "bucket" {
  bucket = local.bucket_name
  acl    = "private"
}

resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.bucket.id
  key    = "index.html"
  source = "./files/index.html"
  etag   = filemd5("./files/index.html")
}
resource "aws_s3_bucket_object" "callback" {
  bucket = aws_s3_bucket.bucket.id
  key    = "callback.html"
  source = "./files/callback.html"
  etag   = filemd5("./files/callback.html")
}
resource "aws_s3_bucket_object" "user" {
  bucket = aws_s3_bucket.bucket.id
  key    = "user.html"
  source = "./files/user.html"
  etag   = filemd5("./files/user.html")
}

####### OAI #######
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "OAI for CF created by Terraform"
}

resource "aws_s3_bucket_policy" "bucketpolicy" {
  bucket = element(concat(aws_s3_bucket.bucket.*.id, list("")), 0)
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { "AWS" : aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn }
        Action    = "s3:GetObject"
        Resource = [
          element(concat(aws_s3_bucket.bucket.*.arn, list("")), 0),
          join("", [element(concat(aws_s3_bucket.bucket.*.arn, list("")), 0), "/*"])
        ]
      },
    ]
  })
}
############ MONITORING ###########

