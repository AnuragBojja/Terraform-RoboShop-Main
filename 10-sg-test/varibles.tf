variable "env" {
  default = "dev"
}
variable "project_name" {
  default = "roboshop"
}
variable "sg_names" {
  default = [
    #databases
    "mongodb","redis","rabbitmq","mysql",

    #backend
    "catalogue","cart","user","payment","shipping",

    #frontend
    "frontend",

    #bastion_host
    "bastion",
    #OpenVPN
    "openvpn",
    
    #load Balancers
    "frontend_alb","backend_alb"
    ]
}
