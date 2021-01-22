output elb_address {
  value       = module.ec2_elb_classic.elb_address
  sensitive   = false
}
