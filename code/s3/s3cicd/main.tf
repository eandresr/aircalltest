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


############ MONITORING ###########

