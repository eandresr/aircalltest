profile = "terraform"
region  = "eu-west-1"
cloud   = "aws"
project = "aircalltest"
env     = "dev"
service = "cicd"

build_timeout  = 5
source_version = null

build_compute_type = "BUILD_GENERAL1_SMALL"
build_image        = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"

build_type            = "LINUX_CONTAINER"
privileged_mode       = true
environment_variables = [{ "name" : "Project", "value" : "aircall", "type" : "string" }]
source_type           = "CODECOMMIT"
source_location       = ""