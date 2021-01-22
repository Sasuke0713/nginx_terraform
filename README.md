# nginx_terraform
Terraform code to setup simple nginx service in AWS

# How to Run the project?
Below are commands needed to run the nginx service without standing up a VPC(ec2_elb_classic), and another to stand up a VPC along with the EC2 and ELB(ec2_elb_vpc)

```
make plan WORKSPACE=<environment> PATH=<ec2_elb_classic>,<ec2_elb_vpc>
make apply WORKSPACE=<environment> PATH=<ec2_elb_classic>,<ec2_elb_vpc>
make destroy WORKSPACE=<environment> PATH=<ec2_elb_classic>,<ec2_elb_vpc>
```
