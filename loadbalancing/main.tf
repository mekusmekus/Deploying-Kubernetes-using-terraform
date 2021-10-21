# -- loadbalancing/main.tf


resource "aws_lb" "my_lb" {

  name            = "my-loadbalancer"
  subnets         = var.public_subnets
  security_groups = [var.public_sg]
  idle_timeout    = 400


}

resource "aws_lb_target_group" "my_tg" {

  name     = "my-lb-${substr(uuid(), 0, 3)}"
  port     = var.my_port
  protocol = var.my_protocol
  vpc_id   = var.vpc_id
  lifecycle{
      ignore_changes = [name] 
      create_before_destroy = true
  } 
  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }

}

resource "aws_lb_listener" "my_lb_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }

}