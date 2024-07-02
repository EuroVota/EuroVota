resource "aws_lb_target_group" "users-tg2" {
  name     = "${var.prefix}-users-lb-tg-2${var.suffix}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "users-tg-attachment" {
  target_group_arn = aws_lb_target_group.users-tg2.arn
  target_id        = var.instance_id
  port             = 8080
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
  name               = "${var.prefix}-users-lb-${var.suffix}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.euro-vota-sg.id]
  subnets            = [for subnet_id in var.private_subnets_ids : subnet_id]

  enable_deletion_protection = true


  tags = {
    Name = "${var.prefix}-users-lb-${var.suffix}"
  }
}

resource "aws_lb_listener" "users-lb-listener" {
  load_balancer_arn = aws_lb.users-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.users-tg2.arn
  }
}