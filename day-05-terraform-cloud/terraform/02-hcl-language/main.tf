terraform {
  required_version = ">= 1.6.0"
}

variable "environment" {
  type    = string
  default = "dev"
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be dev, test or prod."
  }
}

variable "services" {
  type    = set(string)
  default = ["api", "web"]
}

locals {
  prefix = "day5-${var.environment}"
}

resource "terraform_data" "service" {
  for_each = var.services
  input    = "${local.prefix}-${each.key}"
}

output "service_names" {
  value = [for v in terraform_data.service : v.output]
}
