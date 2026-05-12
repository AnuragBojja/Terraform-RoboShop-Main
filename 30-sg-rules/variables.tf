variable "env" {
  default = "dev"
}
variable "project_name" {
  default = "roboshop"
}
variable "openvpn-ports" {
  default = {
    https = {
      port = 443
    }
    udp = {
      port = 1194
    }
    admin = {
      port = 943
    }
    shh = {
      port = 22
    }
  }
}