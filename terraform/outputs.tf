output "chatapp1_instance_public_ip_addr" {
  value = aws_instance.chatapp1.public_ip
}

output "chatapp2_instance_public_ip_addr" {
  value = aws_instance.chatapp2.public_ip
}

output "chatapp_aws_elb_public_dns" {
  value = aws_elb.chatapp.dns_name
}