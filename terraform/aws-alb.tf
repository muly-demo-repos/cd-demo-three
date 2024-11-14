
module "ecs_alb_sg_paz" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name   = "paz"
  vpc_id = module.vpc.vpc_id

  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = module.vpc.private_subnets_cidr_blocks
}

module "ecs_alb_paz" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.7.0"

  name = "paz"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.ecs_alb_sg_paz.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
  ]

  target_groups = [
    {
      name             = "paz"
      backend_protocol = "HTTP"
      backend_port     = 5202
      target_type      = "ip"

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/api/_health/live"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-299"
      }
    },
  ]
}