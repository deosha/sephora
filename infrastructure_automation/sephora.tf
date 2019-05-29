terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "infra_state" {
  backend = "s3"
  config {
    bucket = "sephora-state-files"
    key = "${var.env}/sephora.tfstate"
    region = "${var.region}"
  }
}

module "Network-And-DNS" {
  source = "./modules/Network-And-DNS"
  env = "${var.env}"
  health_check_path = "${var.health_check_path}"
  deregistration_delay = "${var.deregistration_delay}"
  security_group = "${module.Security-And-Authentications.alb-sg-id}"
}

module "Security-And-Authentications" {
  source = "./modules/Security-And-Authentications"
  env = "${var.env}"
  vpc_id = "${module.Network-And-DNS.id}"
}

module "Instances-And-LoadBalancers" {
  source = "./modules/Instances-And-LoadBalanacers"
  private_subnet_ids = ["${module.Network-And-DNS.private_subnet_id1}, ${module.Network-And-DNS.private_subnet_id2}"]
  public_subnet_ids = ["${module.Network-And-DNS.public_subnet_id1}, ${module.Network-And-DNS.public_subnet_id2}"]
  public_subnet_id = "${module.Network-And-DNS.public_subnet_id1}"
  vpc_id = "${module.Network-And-DNS.id}"
  cluster = "${module.Containers.cluster_name}"
  env = "${var.env}"
  key_name = "${var.key_pair_name}"
  alb_target_group_arn = "${module.Network-And-DNS.alb_target_group_arn}"
  security_group = "${module.Security-And-Authentications.asg-sg-id}"
  nat_gateway1_id = "${module.Network-And-DNS.nat_gateway1_id}"
  nat_gateway2_id = "${module.Network-And-DNS.nat_gateway2_id}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${module.Security-And-Authentications.ecs-asg-iam-instance-profile-name}"
}

module "Containers" {
  source = "./modules/Containers/ecs"
  env = "${var.env}"
  region = "${var.region}"
  tag = "${var.tag}"
  alb_target_group_arn = "${module.Network-And-DNS.alb_target_group_arn}"
}



