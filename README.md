# nginx_terraform
Terraform code to setup simple nginx service in AWS

# How to Run the project?
Below are commands needed to run the nginx service without standing up a VPC(ec2_elb_classic), and another to stand up a VPC along with the EC2 and ELB(ec2_elb_vpc). You must run a `make plan` first to ensure the `terraform init` command runs and best practice to not just apply changes...

```
make plan WORKSPACE=<environment> PATH=<ec2_elb_classic>,<ec2_elb_vpc>
make apply WORKSPACE=<environment> PATH=<ec2_elb_classic>,<ec2_elb_vpc>
make destroy WORKSPACE=<environment> PATH=<ec2_elb_classic>,<ec2_elb_vpc>
```

# Run Nginx Service without creating VPC example

```
make plan WORKSPACE=dev PATH=ec2_elb_classic
make apply WORKSPACE=dev PATH=ec2_elb_classic
make destroy WORKSPACE=dev PATH=ec2_elb_classic
```

# Run Nginx Service with the creation of your own VPC with public and private subnets along with routing

```
make plan WORKSPACE=dev PATH=ec2_elb_vpc
make apply WORKSPACE=dev PATH=ec2_elb_vpc
make destroy WORKSPACE=dev PATH=ec2_elb_vpc
```
