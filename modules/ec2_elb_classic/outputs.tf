output elb_address {
  value       = aws_elb.service_webserver_elb.dns_name
  sensitive   = false
}
