variable "aws_region" {
  description = "Value of the Name of the Region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "aws_availability_zone_a" {
  description = "Value of the Name of the Availability Zone a"
  type        = string
  default     = "us-east-1a"
}

variable "aws_availability_zone_b" {
  description = "Value of the Name of the Availability Zone b"
  type        = string
  default     = "us-east-1b"
}

variable "application" {
  description = "Value of the Name of the Application to run"
  type        = string
  default     = "chatapp"
}

variable "ami" {
  description = "Map containing the accepted ami-id's by region"
  type        = map(any)
  default = {
    "us-east-1" : "ami-09e67e426f25ce0d7"
  }
}

variable "public-ssh-key-path" {
  description = "Local path where public ssh key file was generated"
  type        = string
}