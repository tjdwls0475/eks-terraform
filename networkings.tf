resource "aws_vpc" "rlt_vpc" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = true
    tags = {
        Name = "rlt-vpc"
    }
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
    vpc_id = aws_vpc.rlt_vpc.id
    cidr_block = var.secondary_cidr
}

resource "aws_internet_gateway" "rlt_igw" {
    vpc_id = aws_vpc.rlt_vpc.id
    tags = {
        Name = "rlt-igw"
    }
}

resource "aws_subnet" "rlt_mgmt_subnet" {
    vpc_id = aws_vpc.rlt_vpc.id
    cidr_block = "84.20.10.0/28"
    availability_zone = "${var.region}c"
    map_public_ip_on_launch = true
    tags = {
        Name = "rlt-mgmt-subnet"
    }
}

resource "aws_subnet" "rlt_k8s_subnet_c" {
    vpc_id = aws_vpc.rlt_vpc.id
    cidr_block = "84.20.10.64/26"
    availability_zone = "${var.region}c"
    map_public_ip_on_launch = true
    tags = {
        Name = "rlt-k8s-subnet-c"
    }
}

resource "aws_subnet" "rlt_k8s_subnet_a" {
    vpc_id = aws_vpc.rlt_vpc.id
    cidr_block = "84.20.11.64/26"
    availability_zone = "${var.region}a"
    map_public_ip_on_launch = true
    tags = {
        Name = "rlt-k8s-subnet-a"
    }
    depends_on = [
        aws_vpc_ipv4_cidr_block_association.secondary_cidr
    ]
}

resource "aws_route_table" "rlt_rt" {
    vpc_id = aws_vpc.rlt_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.rlt_igw.id
    }
    tags = {
        Name = "rlt-rt"
    }
}

resource "aws_route_table_association" "rlt_rt_ass_mgmt" {
    subnet_id = aws_subnet.rlt_mgmt_subnet.id
    route_table_id = aws_route_table.rlt_rt.id
}

resource "aws_route_table_association" "rlt_rt_ass_k8s_c" {
    subnet_id = aws_subnet.rlt_k8s_subnet_c.id
    route_table_id = aws_route_table.rlt_rt.id
}

resource "aws_route_table_association" "rlt_rt_ass_k8s_a" {
    subnet_id = aws_subnet.rlt_k8s_subnet_a.id
    route_table_id = aws_route_table.rlt_rt.id
}

resource "aws_security_group" "rlt_sg" {
    name = "rlt-sg"
    description = "To Allow Everything"
    vpc_id = aws_vpc.rlt_vpc.id
    ingress {
        from_port = 22
        to_port = 22
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
        Name = "rlt-sg"
    }
}