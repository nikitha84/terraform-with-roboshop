# module "component" {
#     source = "../../terrafrom-roboshop-component"
#     component = var.component
#     rule_priority = var.rule_priority
# }

module "components" {
  source = "git::https://github.com/nikitha84/terraform-with-roboshop.git?ref=main"
  #loop component & rule priority
  for_each = var.components
  component = each.key
  rule_priority = each.value.rule_priority
}