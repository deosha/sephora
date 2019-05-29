resource "aws_ecs_cluster" "ecs-cluster" {
  name = "sephora-${var.env}"
}

resource "aws_cloudwatch_log_group" "frontend_log_group" {
  name = "sephora-frontend-${var.env}"
  retention_in_days = 30
  tags {
    Environment = "${var.env}"
    Application = "sephora-frontend"
    Project = "sephora"
  }
}

data "template_file" "frontend_task" {
  template = "${file("modules/Containers/ecs/task-definitions/frontend.json")}"

  vars {
    region = "${var.region}"
    project = "sephora"
    env = "${var.env}"
    tag = "${var.tag}"
  }
}

data aws_ecs_task_definition "frontend" {
  task_definition = "${aws_ecs_task_definition.frontend.family}"
}


resource "aws_ecs_task_definition" "frontend" {
  family = "frontend"
  container_definitions = "${data.template_file.frontend_task.rendered}"
  network_mode = "bridge"
  requires_compatibilities = [
    "EC2"]
}

resource "aws_ecs_service" "frontend" {
  name = "sephora-frontend"
  cluster = "${aws_ecs_cluster.ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.frontend.family}:${max("${aws_ecs_task_definition.frontend.revision}","${data.aws_ecs_task_definition.frontend.revision}")}"
  desired_count = 1
  launch_type = "EC2"
  scheduling_strategy = "REPLICA"
  deployment_maximum_percent = "100"
  deployment_minimum_healthy_percent = "50"


  ordered_placement_strategy {
    type = "binpack"
    field = "cpu"
  }

  placement_constraints {
    type = "distinctInstance"
  }

  provisioner "local-exec" {
    command = "sleep 60"
  }
}
