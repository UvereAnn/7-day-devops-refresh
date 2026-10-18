terraform {
  required_version = ">= 1.6.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "hello" {
  filename = "${path.module}/terraform-created.txt"
  content  = "Terraform created this file.\n"
}

output "created_file" {
  value = local_file.hello.filename
}
