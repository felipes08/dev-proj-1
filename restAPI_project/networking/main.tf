variable "vpc_id" {}
variable "public_subnet_id" {}
variable "private_subnet_ids" {}

output "vpc_id" {
  value       = data.aws_vpc.rede_existente.id
}

output "public_subnet_ids" {
  value = [
    data.aws_subnet.subnet_publica_1.id,
    data.aws_subnet.subnet_publica_2.id
  ]
}

output "public_subnet_id_1" {
  value       = data.aws_subnet.subnet_publica_1.id
}

output "private_subnet_group_ids" {
  value = [
    data.aws_subnet.subnet_privada_rds_1.id,
    data.aws_subnet.subnet_privada_rds_2.id
  ]
}

output "private_subnet_cidr_block" {
  value = [
    data.aws_subnet.subnet_privada_rds_1.cidr_block,
    data.aws_subnet.subnet_privada_rds_2.cidr_block
  ]
}

output "public_subnet_cidr_block" {
  value = [
    data.aws_subnet.subnet_publica_1.cidr_block,
    data.aws_subnet.subnet_publica_2.cidr_block
  ]
}







data "aws_vpc" "rede_existente" {
  id = var.vpc_id
}
data "aws_subnet" "subnet_publica_1" {
  id = var.public_subnet_id[0]
}

data "aws_subnet" "subnet_publica_2" {
  id = var.public_subnet_id[1]
}

data "aws_subnet" "subnet_privada_rds_1" {
  id = var.private_subnet_ids[0]
}

data "aws_subnet" "subnet_privada_rds_2" {
  id = var.private_subnet_ids[1]
}