#===============================================
# Application Load Balancer Configuration
#
# Load balancing for ECS services
# Dependencies:
# - VPC/subnets (network.tf)
# - Security groups (main.tf → will move to security-groups.tf)
#===============================================

#---------------------------------------
# Application Load Balancer
#---------------------------------------

# ALB作成 (VPC Origins用: internal ALB)
resource "aws_lb" "alb" {
  name               = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-alb"
  internal           = true  # VPC Origins用にプライベート化
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.private_subnet[*].id  # プライベートサブネットに移動
  idle_timeout       = 180
  tags               = local.common_tags
}

#---------------------------------------
# Target Group
#---------------------------------------

# ターゲットグループ作成
resource "aws_lb_target_group" "alb_tg" {
  name        = "${local.app_identifier}-${local.environment}-${local.aws_region_string}-alb-tg"
  port        = 3000
  # port        = 80 # TODO
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
  health_check {
    healthy_threshold   = 2    # 2回連続成功でhealthy
    unhealthy_threshold = 8    # 8×10=80秒 マイグレーション時間を考慮
    timeout             = 5    # 10→5秒 レスポンス待機時間短縮
    interval            = 10   # 60→10秒 高頻度チェックで早期成功検出
    path                = "/health"
    matcher             = "200-299"
  }
  tags = local.common_tags
}

#---------------------------------------
# Load Balancer Listener
#---------------------------------------

# HTTPSリスナー (CloudFront→ALB用)
resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.alb_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }

  tags = merge({
    Name = "${local.app_identifier}-${local.environment}-alb-https-listener"
  }, local.common_tags)

  depends_on = [aws_acm_certificate_validation.alb_cert_validation]
}