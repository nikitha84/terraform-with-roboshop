locals {
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_name_suffix = "${var.project_name}-${var.environment}"
}