variable "env" {
  default = "dev"
}
variable "project_name" {
  default = "roboshop"
}
variable "bastion_tags" {
  default = {
    instance = "bastion"
    }
}

variable "instance_type" {
  default = "t3.micro"
}