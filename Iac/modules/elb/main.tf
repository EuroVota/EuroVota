resource "aws_lb_target_group" "users-tg" {
  name     = "${var.prefix}-users-lb-tg${var.suffix}"
  port     = 9000
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    port                = "traffic-port"
    path                = "/actuator/health"
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "HTTP"
  }
}

resource "aws_security_group" "euro-vota-sg" {
  name = "euro-vota-sg-${var.suffix}"
  description = "SG Euro vota for ELB"
  vpc_id      = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.prefix}euro-vota-sg-${var.suffix}"
  }
}

resource "aws_lb" "users-lb" {
  name               = "${var.prefix}-users-nlb-${var.suffix}"
  internal           = true
  load_balancer_type = "network"
  security_groups    = [aws_security_group.euro-vota-sg.id]
  subnets            = [for subnet_id in var.private_subnets_ids : subnet_id]

  enable_deletion_protection = true


  tags = {
    Name = "${var.prefix}-users-nlb-${var.suffix}"
  }
}

resource "aws_lb_listener" "users-lb-listener" {
  load_balancer_arn = aws_lb.users-lb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.users-tg.arn
  }
}

resource "aws_lb_target_group" "votes-tg" {
  name     = "${var.prefix}-votes-nlb-tg-${var.suffix}"
  port     = 9002
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    port                = "traffic-port"
    path                = "/actuator/health"
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "HTTP"
  }

}

resource "aws_lb" "votes-nlb" {
  name               = "${var.prefix}-votes-nlb-${var.suffix}"
  internal           = true
  load_balancer_type = "network"
  security_groups    = [aws_security_group.euro-vota-sg.id]
  subnets            = [for subnet_id in var.private_subnets_ids : subnet_id]

  enable_deletion_protection = true


  tags = {
    Name = "${var.prefix}-votes-nlb-${var.suffix}"
  }
}

resource "aws_lb_listener" "votes-lb-listener" {
  load_balancer_arn = aws_lb.votes-nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.votes-tg.arn
  }
}