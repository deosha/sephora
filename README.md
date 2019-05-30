# README
[![Build Status](https://travis-ci.org/deosha/sephora.svg?branch=master)](https://travis-ci.org/deosha/sephora)


* Ruby version: 2.3.3 with Rails 5.0.1

* System dependencies: The deployment can be done from Windows/Linux/macos but infrastructure is created on AWS

* Configuration: You need to have Terraform binary(Try avoiding 0.12 because many things have changed. 0.11 will work best). You need to configure AWS access keys and secret keys for terraform to read

* Database creation: sqllite is used for now due to pricing constraints. RDS is recommended for high avalaibility and RDS with read replica for high read/write

* Database initialization: secrets.yml is added in .gitignore. Contents of secrets.yml:
development:
  secret_key_base: <%= ENV["SECRET_KEY_BASE_DEV"] %>
test:
  secret_key_base: <%= ENV["SECRET_KEY_BASE_TEST"] %>
production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE_PROD"] %>

  config/application.rb is used to read these env variables.

* How to run the test suite: NA

* Deployment instructions:
cd infrastructure_automation
terraform init -backend-config="bucket=sephora-state-files" -backend-config="key=demo/sephora.tfstate" -backend-config="region=us-west-2" -backend=true -force-copy -get=true -input && terraform apply -input=false --auto-approve --var-file=sephora.tfvars

You need to set AWS ACCESS KEY ID and AWS SECRET ACCESS KEY. Then you can hit <instance-public-ip> on browser to open rails blank page

* Logging and Monitoring: Can be viewed in Cloudwatch logs after deployment. Monitoring yet to be done

* CI: .travis.yml is in repository. Jenkinsfile can be committed if needed


