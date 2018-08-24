# Terraform backend should come from terraform_config.tf

# Set up AWS provider with our region
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "${var.aws_region}"
}

## Route53 hosted zone
# We need to create a new hosted zone for the service
resource "aws_route53_zone" "domain" {
  name = "${var.name}.${var.domain}"
}

# We will then need to configure the base donain to have a NS record
# pointing to the name servers for our route53 zone
data "aws_route53_zone" "base_domain" {
  name = "${var.domain}"
}
resource "aws_route53_record" "domain_ns" {
  zone_id = "${data.aws_route53_zone.base_domain.zone_id}"
  name = "${aws_route53_zone.domain.name}"
  type = "NS"
  ttl = "300"
  records = ["${aws_route53_zone.domain.name_servers}"]
}

# Now we can generate additional records within our subdomain - handled by kops

# We also need to add a bucket to store kubernetes state
resource "aws_s3_bucket" "k8s_state" {
  bucket = "core.${var.name}.kubernetes.state.store"
  acl = "private"
}