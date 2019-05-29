# This is a custom file which has been created to dynamically pass certain variables to our main terraform file, as per the AWS architecture designed for PCL.
# The values of these variables are based on certain assumptions & shall be modified accordingly when used by a developer to suit his infrastructure setup requirements.
# Please treat this file as a reference to create your own before attempting to run terraform engine.

# Allocate a set of flexible IP's using CIDR (Classless Inter-Domain Routing) for the VPC, which is an optimized software-defined network (SDN) within AWS.
# Read more as to how many IP's you should need for a practical setup - https://medium.com/aws-activate-startup-blog/practical-vpc-design-8412e1a18dcc
vpc_cidr = "10.0.0.0/16"
region = "us-west-2"

# Populate this value to reflect the name of your software environment for the project, ideally in the form of project-environment
env = "demo"
key_pair_name = "sephora"
instance_type = "t2.micro"
