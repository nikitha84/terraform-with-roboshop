resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
  subnet_id = local.database_subnet_id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-mongodb"
    }
  )
}

resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
  subnet_id = local.database_subnet_id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-redis"
    }
  )
}

resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  subnet_id = local.private_subnet_id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-catalogue"
    }
  )
}

resource "aws_instance" "user" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.user_sg_id.value]
  subnet_id = local.private_subnet_id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-user"
    }
  )
}
resource "aws_instance" "cart" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.cart_sg_id.value]
  subnet_id = local.private_subnet_id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-cart"
    }
  )
}

resource "aws_instance" "frontend" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]
  subnet_id = local.public_subnet_id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-frontend"
    }
  )
}

resource "aws_instance" "ansible" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  user_data = file("ec2-provision.sh")
  subnet_id = local.public_subnet_id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-ansible"
    }
  )
}


#DNS records
resource "aws_route53_record" "mongodb" {
  zone_id = var.zone_id
  name    =  "mongodb" #mongodb-dev.daws84s.site
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "redis" {
  zone_id = var.zone_id
  name    =  "redis" 
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
  allow_overwrite = true
}
resource "aws_route53_record" "catalogue" {
  zone_id = var.zone_id
  name    =  "catalogue" 
  type    = "A"
  ttl     = 1
  records = [aws_instance.catalogue.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "user" {
  zone_id = var.zone_id
  name    =  "user"
  type    = "A"
  ttl     = 1
  records = [aws_instance.user.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "cart" {
  zone_id = var.zone_id
  name    =  "cart" 
  type    = "A"
  ttl     = 1
  records = [aws_instance.cart.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "frontend" {
  zone_id = var.zone_id
  name    =  "frontend"
  type    = "A"
  ttl     = 1
  records = [aws_instance.frontend.private_ip] #we r using vpn so private ip will work
  allow_overwrite = true
  depends_on = [aws_instance.frontend]
}






