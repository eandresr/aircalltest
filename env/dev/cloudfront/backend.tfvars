profile        = "terraform"
region         = "eu-west-1"
bucket         = "aws-aircalltest-dev-statebucket"
key            = "aircalltest/cloudfront/dev/terraform.tfstate"
encrypt        = true
dynamodb_table = "aws-aircalltest-dev-statetable"



# We need to have previously created the following: 
# - DynamoDB table with the PartitionKey named LockID
# - S3 Bucket with versioning enabled