module "sg" {
  count = length(var.sg_names)
    #source = "../../terraform-aws-sg"
    source = "git::https://github.com/nikitha84/terraform-aws-sg.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = var.sg_names[count.index]
    sg_description = "Sg for ${var.sg_names[count.index]}"
     vpc_id = local.vpc_id
    #sg_ingress_rules = var.mongodb_sg_ingress_rules

}

# module "catalogue" {
#     source = "../../terraform-aws-sg"
#     project_name = var.project_name
#     environment = var.environment
#     vpc_id = data.aws_ssm_parameter.vpc_id.value
#     sg_name = "catalogue"
#     sg_description = "Sg for catalogue"
#     #sg_ingress_rules = var.catalogue_sg_ingress_rules

# }



# resource "aws_security_group_rule" "mongodb_catalogue" {
#   source_security_group_id = module.catalogue.sg_id
#  type              = "ingress"
#   from_port         = 27017
#   to_port           = 27017
#   protocol          = "tcp"
#   security_group_id = module.mongodb.sg_id
# }




