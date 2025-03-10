provider "aws" {
  region = "us-east-1"
}

resource "aws_elastic_beanstalk_application" "reg_app" {
  name        = "reg-app"
  description = "Elastic Beanstalk application for reg-app"
}

resource "aws_iam_instance_profile" "reg_app_instance_profile" {
  name = "eks-project"
}


resource "aws_elastic_beanstalk_application_version" "app_version" {
  name        = "reg-app-version-label"
  application = aws_elastic_beanstalk_application.reg_app.name
  description = "application version created by terraform"
  bucket      = "demo-bucket-03-09-2025-new"
  key         = "webapp.war"
}

resource "aws_elastic_beanstalk_environment" "app_env" {
  name                = "reg-app-dev"
  application         = aws_elastic_beanstalk_application.reg_app.name
  version_label       = aws_elastic_beanstalk_application_version.app_version.id
  solution_stack_name = "64bit Amazon Linux 2 v4.7.7 running Tomcat 9 Corretto 11"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "eks-project"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "ServiceRole"
    value = "aws-elasticbeanstalk-service-role"
  }
}

output "beanstalk_url" {
  value = aws_elastic_beanstalk_environment.app_env.endpoint_url
}
