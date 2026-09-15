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

variable "zone_id"{
    default = "Z00715171J4Q20OOSFL1T"
}
variable "zone_name"{
    default = "nikitha.fun"
}