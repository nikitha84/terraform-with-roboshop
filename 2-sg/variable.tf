variable "common_tags" {
    type = map
    default = {
        project = "roboshop"
        Environment = "Dev"
        Terraform = "true"
    }
}  

variable "project_name" {
    default = "roboshop"
}
variable "environment" {
    default = "dev"
}
variable "sg_tags" {
    type = map
    default = {}
}
#looping all sg 
variable "sg_names" {
  default = [
    #databases
    "mongodb", "redis", "mysql", "rabbitmq",

    #backend
    "catalogue", "user", "cart", "shipping", "payment",

    #frontend
    "frontend",

    #bastion
    "bastion",

    #frontend load balancer,
    "frontend_alb",

    #backend
    "backend_alb",


    ]
}
variable "ports_vpn" {
    default = ["22", "943", "1194", "443"]
}
variable "mongodb_ports_vpn" {
  default = ["22", "27017"]
}
variable "redis_ports_vpn" {
  default = ["22", "6379"]
}
# variable "mysql_ports_vpn" {
#   default = ["22", "3306"]
# }





