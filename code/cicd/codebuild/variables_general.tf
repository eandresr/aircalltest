######## GENERAL ########
variable "profile" {
  type        = string
  description = "The provider CLI profile credentials"
  default     = "terraform"
}
variable "statebucket" {
  type        = string
  description = "The global State bucket"
  default     = "aws-aircalltest-dev-statebucket"
}
######## Naming #########
variable "region" {
  type        = string
  description = "The region where we want to create the resources, by default Ireland buy may change if you want, ie. by your GDPR or latency, etc."
  default     = "eu-west-1"
}
variable "cloud" {
  type        = string
  description = "The Cloud provider to help us in the naming"
  default     = ""
}
variable "project" {
  type        = string
  description = "The project what we are deploying for"
  default     = ""
}
variable "env" {
  type        = string
  description = "Environment, will be used by the naming"
  default     = ""
}
variable "service" {
  type        = string
  description = "Service name or propouse of this group of components for using in the naming, example <deployment> if we are creating services for the cicd part"
  default     = ""
}

###### SPECIFIC ######
variable "build_timeout" {
  default     = 60
  description = "How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed"
}
variable "source_version" {
  type        = string
  default     = ""
  description = "A version of the build input to be built for this project. If not specified, the latest version is used."
}
variable "build_compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "Instance type of the build instance"
}
variable "build_image" {
  type        = string
  default     = "aws/codebuild/standard:2.0"
  description = "Docker image for build environment, e.g. 'aws/codebuild/standard:2.0' or 'aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html"
}
variable "build_type" {
  type        = string
  default     = "LINUX_CONTAINER"
  description = "The type of build environment, e.g. 'LINUX_CONTAINER' or 'WINDOWS_CONTAINER'"
}
variable "privileged_mode" {
  type        = bool
  default     = false
  description = "(Optional) If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images"
}
variable "environment_variables" {
  type = list(object(
    {
      name  = string
      value = string
      type  = string
  }))

  default = [
    {
      name  = "NO_ADDITIONAL_BUILD_VARS"
      value = "TRUE"
      type  = "PLAINTEXT"
  }]

  description = "A list of maps, that contain the keys 'name', 'value', and 'type' to be used as additional environment variables for the build. Valid types are 'PLAINTEXT', 'PARAMETER_STORE', or 'SECRETS_MANAGER'"
}
variable "source_type" {
  type        = string
  default     = "CODEPIPELINE"
  description = "The type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, BITBUCKET or S3"
}
variable "source_location" {
  type        = string
  default     = ""
  description = "The location of the source code from git or s3"
}



