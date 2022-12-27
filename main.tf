terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.66.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # Canonical
  owners = ["099720109477"]
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "jpal_tf"
  vpc_security_group_ids = ["sg-082f9e755aac10fc8"]

  associate_public_ip_address = true

  #userdata
  user_data = <<EOF
#!/bin/bash
apt-get -y update
apt-get -y install nginx
service nginx start
echo fin v1.00!
EOF

  tags = {
    Name = "test-terra"
  }
}