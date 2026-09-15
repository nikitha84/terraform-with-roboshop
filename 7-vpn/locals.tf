locals {
   ec2_name = "${var.project_name}-${var.environment}"
   ami_id = data.aws_ami.rhel9.id
   public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
   
}