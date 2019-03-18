# AWS VPC

## Summary
This Terraform module creates a basic 3-tier VPC with routing.

## What does it create?

- VPC
- Public/Private/Data subnets in as many zones as you specified:
  - Public subnets have public IP address mapping enabled
  - Private/Data subnets do not
- Public/Private/Data route tables and necessary associations:
  - Public subnets can directly access the internet
  - Private subnets use a NAT gateway to access the internet
  - Data subnets cannot access the internet at all
- RDS Subnet group: gets created when there is more than 1 Data subnet
- NAT gateway:
  - An EIP is associated with the NAT gateway
  - To keep cost (and EIP allocation) in check, only 1 NAT gateway is created in the first public subnet

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_region | AWS region to use | string | n/a | yes |
| env\_name | Name our environment. Used for tagging in AWS | string | n/a | yes |
| vpc\_cidr\_second\_octet |  | string | `"0"` | no |
| vpc\_data\_subnet\_prefix |  | string | `"3"` | no |
| vpc\_private\_subnet\_prefix |  | string | `"2"` | no |
| vpc\_public\_subnet\_prefix |  | string | `"1"` | no |
| zone\_count | Amount of AWS zones we want to use for this VPC | string | `"1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| outputs | Module outputs that are strings |
| outputs-list | Module outputs that are lists |

