output elb_address {
  value       = module.ec2_elb_vpc.elb_address
  sensitive   = false
}
