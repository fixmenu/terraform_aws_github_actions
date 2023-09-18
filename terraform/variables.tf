variable "github_secret" {
    type = string
}

variable "aws_region" {
  type = string
  default = "eu-central-1"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}