output "alb_dns_name" {
  description = "Public DNS of the Application Load Balancer"
  value       = "http://${aws_lb.main.dns_name}"
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.app.name
}

output "target_group_arn" {
  description = "ALB Target Group ARN"
  value       = aws_lb_target_group.app.arn
}
