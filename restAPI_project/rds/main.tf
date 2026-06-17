variable "db_name" {}
variable "db_username" {}
variable "db_password" { sensitive = true }
variable "private_subnet_ids" {}
variable "vpc_security_group_ids" {}
/*I
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "dev_proj_1_rds_subnet_group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "mysql_db" {
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  identifier             = "mydb"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.vpc_security_group_ids]
  
  skip_final_snapshot    = true
  apply_immediately      = true

  backup_retention_period = 0
  deletion_protection    = false
}*/