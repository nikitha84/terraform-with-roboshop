module "components" {
    source = "../../terrafrom-roboshop-component"
    component = var.components
    rule_priority = var.rule_priority
}

# module "components" {
#   source = "git::https://github.com/nikitha84/terraform-roboshop-component.git?ref=main"
#   #loop component & rule priority
#   for_each = var.components
#   components = each.key
#   rule_priority = each.value.rule_priority
# }