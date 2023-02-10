resource "aws_security_group" "rlt_k8s_sg" {
    name = "rlt-k8s-sg"
    description = "To Allow Everything"
    vpc_id = aws_vpc.rlt_vpc.id
    ingress {
        from_port = 22
        to_port = 35000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "rlt-k8s-sg"
    }
}