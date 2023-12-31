variable "tags" {}
variable "env" {}
variable "subnet_ids" {}
variable "name" {
  default = "rabbitmq"
}
variable "vpc_id" {}
variable "allow_db_cidr" {}
variable "port_number" {
  default = 5672
}
variable "instance_type" {}
variable "bastion_cidr" {}