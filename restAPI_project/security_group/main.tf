variable "vpc_id" {}
variable "api_port" {}
variable "private_subnet_cidr_block" {}
variable "public_subnet_cidr_block" {}

output "api_security_group_id" {
  value       = aws_security_group.api_sg.id
}

output "ec2_sg_ssh_http_https_id" {
  value = data.aws_security_group.ec2_sg_ssh_http_https.id
}

output "rds_mysql_sg_id" {
  value = aws_security_group.rds_mysql_sg.id
}




data "aws_security_group" "ec2_sg_ssh_http_https" {
  id = "sg-0eba53774b6edf38f"
}

resource "aws_security_group" "api_sg" {
  name        = "python-api-sg"
  description = "Enable the Port 5000 for python api"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow port 5000 for python api"
    from_port   = var.api_port
    to_port     = var.api_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outgoing requests"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Group to allow port 5000"
  }
}

resource "aws_security_group" "rds_mysql_sg" {
  name        = "rds-sg"
  description = "Allow access to RDS from EC2 present in public subnet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = concat(var.private_subnet_cidr_block, var.public_subnet_cidr_block)
  }
}