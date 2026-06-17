module "networking" {
  source             = "./networking"
  vpc_id             = "vpc-0ed11de6c1a5d0d65"
  public_subnet_id   = ["subnet-0d0da14359c7786c1", "subnet-049f4db2071ee47e6"]
  private_subnet_ids = ["subnet-0a6e95337fc353c12", "subnet-00e74ecc03235198f"]
}

module "security_group" {
  source   = "./security_group"
  vpc_id   = module.networking.vpc_id
  api_port = 5000
  public_subnet_cidr_block = module.networking.public_subnet_cidr_block
  private_subnet_cidr_block = module.networking.private_subnet_cidr_block
}

module "rds_db_instance" {
  source                 = "./rds"

  private_subnet_ids     = module.networking.private_subnet_group_ids
  vpc_security_group_ids = module.security_group.rds_mysql_sg_id 
  db_password            = var.db_password
  db_name                = "devprojdb"
  db_username            = "dbuser"
}

module "ec2" {
  source                   = "./ec2"
  ami_id                   = var.ami_id
  instance_type            = "t3.micro"
  tag_name                 = "Ubuntu Linux EC2"
  public_key               = var.public_key
  subnet_id                = module.networking.public_subnet_id_1
  sg_enable_ssh_https      = module.security_group.ec2_sg_ssh_http_https_id
  ec2_sg_name_for_python_api     = module.security_group.api_security_group_id
  enable_public_ip_address = true
  user_data_install_python = templatefile("./template/ec2_install_python.sh", {})
}

module "lb_target_group" {
  source                   = "./target-group"
  lb_target_group_name     = "dev-proj-1-tg-restAPI"
  lb_target_group_port     = 5000
  lb_target_group_protocol = "HTTP"
  vpc_id                   = module.networking.vpc_id
  ec2_instance_id          = module.ec2.dev_proj_1_ec2_instance_id
}

module "load_balancer" {
  source = "./load-balancer"
  lb_name = "dev-proj-1-alb"
  lb_target_group_python_arn = module.lb_target_group.dev_proj_1_lb_target_group_arn
  cert_validation = module.certificate_manager.certificate_validation
}

module "hosted_zone" {
  source = "./hosted-zone"
  hz_name = "felipeprojects.dev"
  aws_lb_dns_name = module.load_balancer.lb_dns_name
  aws_lb_zone_id = module.load_balancer.lb_dns_zone_id
}

module "certificate_manager" {
  source = "./certificate-manager"
  domain_name = "felipeprojects.dev"
  hosted_zone_id = module.hosted_zone.dev_proj-1_hz_id
}