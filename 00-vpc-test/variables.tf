variable "vpc_cider" {
  default = "10.0.0.0/16"
}
variable "env" {
  default = "dev"
}
variable "project_name" {
  default = "roboshop"
}
variable "vpc_tags" {
  default = {
    dontdelete = "true"
    Purpose = "vpc"
  }
}
variable "igw_tags" {
  default = {
    dontdelete = "true"
    Purpose = "igw"
  }
}
variable "public_ciders" {
  default = ["10.0.1.0/24","10.0.2.0/24"]
}
variable "private_ciders" {
  default = ["10.0.11.0/24","10.0.12.0/24"]
}
variable "database_ciders" {
  default = ["10.0.21.0/24","10.0.22.0/24"]
}