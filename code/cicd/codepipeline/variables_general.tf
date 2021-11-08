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
variable "pipeline_name" {
  type        = string
  description = "pipeline_name"
  default     = ""
}

