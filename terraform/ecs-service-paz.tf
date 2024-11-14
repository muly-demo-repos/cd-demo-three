module "ecs_service_paz" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.2.2"

  name        = "paz"
  cluster_arn = module.ecs_cluster_paz.arn

  cpu    = 1024
  memory = 4096

  container_definitions = {
    ("paz") = {
      essential = true
      cpu       = 512
      memory    = 1024
      image     = module.ecr_paz.repository_url

      port_mappings = [
        {
          name          = "paz"
          containerPort = 5202
          hostPort      = 5202
          protocol      = "tcp"
        }
      ]

      readonly_root_filesystem  = false
      enable_cloudwatch_logging = false

      log_configuration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/paz"
          awslogs-region        = local.region
          awslogs-stream-prefix = "ecs"
        }
      }

      memory_reservation = 100
    }
  }

  load_balancer = {
    service = {
      target_group_arn = element(module.ecs_alb_paz.target_group_arns, 0)
      container_name   = "paz"
      container_port   = 5202
    }
  }

  subnet_ids = module.vpc.private_subnets

  security_group_rules = {
    alb_ingress = {
      type                     = "ingress"
      from_port                = 5202
      to_port                  = 5202
      protocol                 = "tcp"
      source_security_group_id = module.ecs_alb_sg_paz.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_service_discovery_http_namespace" "paz" {
  name = "paz"
}

output "service_id_paz" {
  description = "ARN that identifies the service"
  value       = module.ecs_service_paz.id
}

output "service_name_paz" {
  description = "Name of the service"
  value       = module.ecs_service_paz.name
}

output "service_iam_role_name_paz" {
  description = "Service IAM role name"
  value       = module.ecs_service_paz.iam_role_name
}

output "service_iam_role_arn_paz" {
  description = "Service IAM role ARN"
  value       = module.ecs_service_paz.iam_role_arn
}

output "service_iam_role_unique_id_paz" {
  description = "Stable and unique string identifying the service IAM role"
  value       = module.ecs_service_paz.iam_role_unique_id
}

output "service_container_definitions_paz" {
  description = "Container definitions"
  value       = module.ecs_service_paz.container_definitions
}

output "service_task_definition_arn_paz" {
  description = "Full ARN of the Task Definition (including both `family` and `revision`)"
  value       = module.ecs_service_paz.task_definition_arn
}
