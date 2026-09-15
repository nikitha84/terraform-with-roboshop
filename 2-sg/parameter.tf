# resource "aws_ssm_parameter" "mongodb_sg_id" { #for mongodb sg id
#   name  = "/${var.project_name}/${var.environment}/mongodb_sg_id"
#   type  = "String"
#   overwrite   = true
#   value = module.mongodb.sg_id
# }
resource "aws_ssm_parameter" "sg_id" {
  count = length(var.sg_names)
  name  = "/${var.project_name}/${var.environment}/${var.sg_names[count.index]}_sg_id" #roboshop-dev-mongodb-sg_id
  type  = "String"
  value = module.sg[count.index].sg_id
  overwrite   = true
}

#write sg for mysql, redis, rabbitmq

# resource "aws_ssm_parameter" "catalogue_sg_id" {
#   name  = "/${var.project_name}/${var.environment}/catalogue_sg_id"
#   type  = "String"
#   value = module.catalogue.sg_id
#   overwrite   = true
# }



