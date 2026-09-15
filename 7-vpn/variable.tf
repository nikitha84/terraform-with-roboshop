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