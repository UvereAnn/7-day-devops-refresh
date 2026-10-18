# Reusable Terraform modules

A module is a directory of HCL configuration with a clear interface. In this masterclass, `aws-network` models a VPC/subnet/routing boundary; `aws-compute` models a VM and its security/identity needs; `gcp-network` models VPC/subnet/firewall inputs. We will develop each from a verified manual cloud lab rather than copying opaque production modules.

## Design contract

1. Define typed inputs with descriptions and validation.
2. Expose stable outputs (IDs, subnet references), not unnecessary secrets.
3. Do not hardcode credentials or regions inside child modules.
4. Document resource cost, security defaults, and whether replacing an input destroys resources.
5. Test `terraform fmt`, `validate`, `test`, and plans from a disposable root module.
6. Pin module versions in real consumers; avoid deep nesting without a reason.

Example consumer:

```hcl
module "network" {
  source   = "../../modules/aws-network"
  vpc_cidr = "10.20.0.0/16"
}
```

This call is **illustrative until the module's input interface has been implemented and validated**.
