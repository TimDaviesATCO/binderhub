# AWS config
variable "aws_region" {
    description = "AWS region"
}
variable "aws_account_id" {
  description = "Our AWS Account ID"
}
variable "aws_access_key" {
    description = "AWS access key"
}
variable "aws_secret_key" {
    description = "AWS secret access key"
}

# Existing AWS infrastructure
variable "domain" {
  type = "string"
  description = "The Route53 domain to deploy DNS records into"
  default = "geo-analytics.io"
}

# Configuration for new services
variable "name" {
  type = "string"
  description = "A name for the new services"
  default = "binder"
}