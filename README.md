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

## Testing

This repository uses [Github Actions](https://github.com/features/actions) for automatic CI. The pipelines are run when a PR is created. However, for external PRs you will have to set this up yourself.

## Testing locally

If you provide your own AWS credentials (the usual environment variables), you can run the pipeline locally using [Act](https://github.com/nektos/act). A JSON file is provided to mock some necessary API responses. To run the pipelines, execute the following:

```
$ act -r -p -e .github/pr-filter-response.json pull_request
```

Customization options:

- In order to have automatic local CI, add the `-w` flag. It will watch the directory for changes, and run the pipeline whenever anything changes.
- If you don't want to send your comments to https://httpstat.us/200, you can run your HTTP echo service (for instance `hashicorp/http-echo`) and update the JSON file accordingly.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| env\_name | Name our environment. Used for tagging in AWS | string | n/a | yes |
| vpc\_cidr\_second\_octet |  | string | `"0"` | no |
| vpc\_data\_subnet\_prefix |  | string | `"3"` | no |
| vpc\_private\_subnet\_prefix |  | string | `"2"` | no |
| vpc\_public\_subnet\_prefix |  | string | `"1"` | no |
| zone\_count | AWS region to useAmount of AWS zones we want to use for this VPC | string | `"1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| outputs | Module outputs that are strings |
| outputs-list | Module outputs that are lists |

The outputs in this module are maps. Wrapping your outputs in maps is especially useful for 'chaining' outputs (module -> plan -> state), and makes for a setup where a change in module output (adding/removing) doesn't require one to update all implementation plans where that module is used.

| Name | Key | Type | Description |
|------|----------|:-----:|-------------|
| outputs | | map | Module outputs that are strings |
| | aws\_region | string ||
| | data\_route\_table\_id | string ||
| | env\_name | string ||
| | internet\_gateway\_id | string ||
| | nat\_gateway\_eip | string ||
| | private\_route\_table\_id | string ||
| | rds\_subnet\_group\_names | string ||
| | vpc\_cidr\_block | string ||
| | vpc\_id | string ||
| | zone\_count  | string ||
| outputs-list | | map | Module outputs that are lists |
| | data\_subnet\_cidr\_blocks | list ||
| | data\_subnet\_ids | list ||
| | private\_subnet\_cidr\_blocks | list ||
| | private\_subnet\_ids | list ||
| | public\_subnet\_cidr\_blocks | list ||
| | public\_subnet\_ids | list ||

