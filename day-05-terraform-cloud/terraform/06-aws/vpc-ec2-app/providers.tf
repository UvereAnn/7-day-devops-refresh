provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project = "day5-terraform-lab"
      Owner   = "learning"
    }
  }
}
