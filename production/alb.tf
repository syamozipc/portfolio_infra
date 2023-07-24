resource "aws_lb" "this" {
  ip_address_type = "ipv4"
  name            = "${local.app_name}-${local.env}"
  security_groups = [aws_security_group.alb.id]
  # TODO:動的にする
  subnets = [for id in local.public_subnet_ids : id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    # host, path, queryはリクエスト値をそのまま使用
    redirect {
      status_code = "HTTP_301"
      protocol    = "HTTPS"
      port        = "443"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  # TODO:動的にする
  certificate_arn = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.id
  }
}

resource "aws_lb_target_group" "this" {
  name     = "${local.app_name}-${local.env}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    matcher = "200"
    path    = "/api"
  }
}

resource "aws_lb_target_group_attachment" "first_ec2" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.first.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "second_ec2" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.second.id
  port             = 8080
}
