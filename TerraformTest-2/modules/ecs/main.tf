resource "aws_ecs_cluster" "stateless" {
  name = "test-to-remove-tf"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

}

resource "aws_ecs_task_definition" "example" {
  container_definitions    = file("${path.module}/task_definition.json")
  cpu                      = "1024"
  execution_role_arn       = "arn:aws:iam::273440013219:role/LabRole"
  family                   = "users-task-tf"
  memory                   = "2048"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  task_role_arn = "arn:aws:iam::273440013219:role/LabRole"
}