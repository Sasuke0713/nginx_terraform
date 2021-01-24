# nginx_terraform
Terraform code to setup simple nginx service in AWS

# Install terraform or tfswitch
TfSwitch is more of a preferred method as terraform versions are forever changing... Assuming you are on MacOSX.
Documentation for install here https://tfswitch.warrensbox.com/Install/. I am using tf version `~> 0.13` for this project but dont worry after installing tfswitch you will see that after setting the `required_version` in the `main.tf` files in `ec2_elb_classic` and `ec2_elb_vpc` it will auto switch you to the correct version.
```
brew install warrensbox/tap/tfswitch
```
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

# Run Nginx Service with the creation of your own VPC with public and private subnets along with routing in a containerized environment running in AWS Fargate

```
make plan WORKSPACE=dev PATH=fargate_alb_vpc
make apply WORKSPACE=dev PATH=fargate_alb_vpc
make destroy WORKSPACE=dev PATH=fargate_alb_vpc
```
