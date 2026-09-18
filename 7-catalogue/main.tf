resource "aws_instance" "catalogue" {
    ami = local.ami_id
    instance_type ="t3.micro"
    vpc_security_group_ids= [local.catalogue_sg_id]
    subnet_id = local.private_subnet_id
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project_name}-${var.environment}-catalogue"
        }
    )

}


resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id,
    
  ]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.catalogue.private_ip
    }
  
  provisioner "file" {
    source      = "catalogue.sh" # Local file path
    destination = "/tmp/catalogue.sh"  # Destination path on the server
  }
  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/catalogue.sh",
        #"sudo sh /tmp/bootstrp.sh "
        "sudo sh /tmp/catalogue.sh catalogue"

    ]
  }
}
resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on = [terraform_data.catalogue] 
}
resource "aws_ami_from_instance" "catalogue" {
  name               = "catalogue-ami"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [aws_ec2_instance_state.catalogue]
}

resource "aws_lb_target_group" "catalogue" {
  name        = "${var.project_name}-${var.environment}-catalogue"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  deregistration_delay = 60 # waiting period before deleting the instance

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 10
    path = "/health"
    protocol = "HTTP"
    timeout = 2
    matcher = "200-299"
    port = 8080
  }
}

resource "aws_launch_template" "catalogue" {
  name = "${var.project_name}-${var.environment}-catalogue"
  image_id = aws_ami_from_instance.catalogue.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.catalogue_sg_id]

  #when we run tf apply, a new version will be created with new ami id
  update_default_version = true

  #tags attch to instances
  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
        {
            Name = "${var.project_name}-${var.environment}-catalogue"
        }
    )
  }

  ##tags attch to the volume created by instance
  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
        {
            Name = "${var.project_name}-${var.environment}-catalogue"
        }
    )
  }

  ##tags attched to the launch template

  tags = merge(
      local.common_tags,
        {
            Name = "${var.project_name}-${var.environment}-catalogue"
        }
    )
}



resource "aws_autoscaling_group" "catalogue" {
  name                 = "${var.project_name}-${var.environment}-catalogue"
  max_size             = 10
  min_size             = 1
  health_check_grace_period = 100
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = false

  launch_template {
    id = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
  }
  vpc_zone_identifier  = local.private_subnet_ids 
  target_group_arns = [aws_lb_target_group.catalogue.arn]
 
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50 #atleast 50% of the instances shold be up
    }
    triggers = ["launch_template"]
  }

  dynamic "tag" { #loop tags
    for_each = merge(
      local.common_tags,
        {
            Name = "${var.project_name}-${var.environment}-catalogue"
        }
    )
    content {
      key                 = tag.key
      propagate_at_launch = true
      value               = tag.value
    }
  }
  timeouts {
    delete = "15m"
  }

}

resource "aws_autoscaling_policy" "catalogue" {
  autoscaling_group_name = "aws_autoscaling_group.catalogue.name"
  name                   = "${var.project_name}-${var.environment}-catalogue"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
      target_value = 75.0
  }
  
}

#listener rule
resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  

  condition {
    host_header {
      values = ["catalogue.backend-alb-${var.environment}.${var.domain_name}"]
    }
  }
}

#delete catalogue instance
resource "terraform_data" "catalogue_local" {
  triggers_replace = [
    aws_instance.catalogue.id,
  ]

  depends_on = [aws_autoscaling_policy.catalogue]
  
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"
  }
}