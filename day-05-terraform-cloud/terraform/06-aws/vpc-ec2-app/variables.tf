variable "aws_region" {
  type    = string
  default = "eu-west-1"
}
variable "key_pair_name" {
  type        = string
  description = "Existing EC2 key pair name in the selected region."
}
variable "ssh_cidr" {
  type        = string
  description = "Your public IPv4 /32, never 0.0.0.0/0."
  validation {
    condition     = can(cidrhost(var.ssh_cidr, 0)) && endswith(var.ssh_cidr, "/32")
    error_message = "ssh_cidr must be a valid IPv4 /32."
  }
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
