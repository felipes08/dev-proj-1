variable "ami_id" {
  type = string
  description = "Ami ID"
}

variable "public_key"{
  type = string
  description = "Public key for SSH in jenkins instances"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Senha do RDS vinda do tfvars"
}