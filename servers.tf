resource "aws_iam_instance_profile" "rlt_mgmt_server_profile" {
    name = "rlt-mgmt-server-profile"
    role = aws_iam_role.rlt_mgmt_server_role.name
}

data "aws_ami" "amzn2" {
    most_recent = true
    owners = ["137112412989"]
    filter {
      name = "name"
      values = ["amzn2-ami-kernel-5.10-hvm*"]
    }
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
}
resource "aws_instance" "rlt_mgmt_server" {
    ami = data.aws_ami.amzn2.id
    instance_type = "t2.micro"
    key_name = "$KEY"
    vpc_security_group_ids = [aws_security_group.rlt_sg.id]
    availability_zone = "${var.region}c"
    associate_public_ip_address = true
    subnet_id = aws_subnet.rlt_mgmt_subnet.id
    iam_instance_profile = aws_iam_instance_profile.rlt_mgmt_server_profile.name
    user_data = "${file("scripts/userdata.sh")}"
    tags = {
        Name = "rlt-mgmt-server"
    }
}