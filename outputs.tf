output "mgmt_server_ip_address" {
  description = "Access IP Address"
  value = aws_instance.rlt_mgmt_server.public_ip
  depends_on = [
    aws_instance.rlt_mgmt_server,
  ]
}

output "rlt_vpc" {
  value = aws_vpc.rlt_vpc.id
}

output "rlt_k8s_subnet_c" {
  value = aws_subnet.rlt_k8s_subnet_c.id
}

output "rlt_k8s_subnet_a" {
  value = aws_subnet.rlt_k8s_subnet_a.id
}

output "rlt_k8s_sg" {
  value = aws_security_group.rlt_k8s_sg.id
}