provider "aws" {
  region  = local.region
  profile = local.profile
}
provider "aws" {
  alias   = "cloudfront"
  region  = "us-east-1"
  profile = local.profile
}