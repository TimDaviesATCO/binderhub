terraform {
    backend "s3" {
        bucket = "core.198499106403.terraform-state"
        key = "scaffold"
        region = "ap-southeast-2"
        dynamodb_table = "core.198499106403.terraform-locks"
        profile = "default"
    }
}
