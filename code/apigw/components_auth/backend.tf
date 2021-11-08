terraform {
  required_version = "~>0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  # TODO: Configuring where the remote state will be stored ...
  backend "s3" {
    # Terraforn does not allow interpolation nor variables or functions here.
    # We are using variables defined in a file and passed to 'init' command like this:
    # terraform init -backend-config=../environment/networking/vpc/backend.tfvars
  }
}