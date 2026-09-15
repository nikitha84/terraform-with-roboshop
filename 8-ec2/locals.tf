locals {
   ec2_name = "${var.project_name}-${var.environment}"
   ami_id = data.aws_ami.rhel9.id
  
  # database_subnet_id = element(split(",", data.aws_ssm_parameter.database_subnet_ids.value), 0)
  # private_subnet_id = element(split(",", data.aws_ssm_parameter.private_subnet_ids.value), 0)
  # public_subnet_id = element(split(",", data.aws_ssm_parameter.public_subnet_ids.value), 0)
  database_subnet_id = split(",", data.aws_ssm_parameter.database_subnet_ids.value)[0]
  private_subnet_id = split(",", data.aws_ssm_parameter.database_subnet_ids.value)[0]
  public_subnet_id = split(",", data.aws_ssm_parameter.database_subnet_ids.value)[0]
}
  