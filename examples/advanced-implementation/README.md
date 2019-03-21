# Advanced implementation

This example describes the basic, and suggested, implementation of this module. It creates a VPC with a 3-tier setup (public/private/data) in 3 availability zones, a NAT gateway in the first public subnet with an Elastic IP, and all the necessary routing.

In this example, we are modifying all possible settings.

## Usage

To run this example, execute:

```
$ terraform init
$ terraform plan
$ terraform apply
```


