# output "frontend_sg_id" {
#   value = module.frontend.sg_id
# }

output "sg_id" {
  value = module.sg[*].sg_id  #get all ids in the the list
}
