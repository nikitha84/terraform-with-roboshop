locals {
    backend_alb_sg_id = data.aws_ssm_parameter.backend_alb_sg_id
    bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id
    mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id
    redis_sg_id = data.aws_ssm_parameter.redis_sg_id
    rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq_sg_id
    mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id
}