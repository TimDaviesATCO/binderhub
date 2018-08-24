# Deploy method for jupyter/binderhub

Jess Robertson, CSIRO
jesse.robertson@csiro.au

This should hopefully be a reasonably complete method for deploying the infrastructure to run automatically-built environments for the Core Skills data science program.

## Deploying binder cluster on AWS

We're going to use a few command line tools to deploy our cluster. The main tools are [`kops`](https://github.com/kubernetes/kops), [`terraform`](https://terraform.io), the AWS command line tools [`awscli`](https://aws.amazon.com/cli) and [`kubectl`](https://kubernetes.io/docs/reference/kubectl/overview) and ['helm'](https://helm.sh/) to manage deployed clusters. Generally the workflow goes like so:

1. use `kops` to generate the basic terraform config that we stash in git
2. use `terraform`'s deploy process to manage actual deployments
3. use `kubectl` and `helm` to manage the deployment of apps onto our cluster

You can install all of these tools on mac using brew:

```bash
$ brew update
$ brew install awscli kops terraform kubernetes-cli kubernetes-helm
```

### Deploying terraform remote state infrastructure

You should only need to do this once when setting up the project. Basically it just creates the storage required for setting up the terraform state.

You can do this using the `script/remote_state.sh` script. You may want to change the following values at the top of the file:

```bash
AWS_REGION="${AWS_REGION:-ap-southeast-2}"
AWS_PROFILE="${AWS_PROFILE:-default}"

# ...

terraform_bucket_name="core.${account_id}.terraform-state"
lock_table="core.${account_id}.terraform-locks"
```

to whatever values you like, although they should be unique to your account to get around the S3 bucket naming requirements. Then create the infrastructure with

```bash
$ ./remote_state create
```
```
Creating an S3 bucket to store terraform state
...
Creating lock table in DynamoDB
...

Once you've created that infrastructure you can generate a terraform configuration file with:

```bash
$ ./remote_state config kubernetes  # or some other identifier
```
```
Remote terraform state storage output to terraform_config.tf
```

The name `workshop` is not special - just something to identify that particular infrastructure as yours.

```bash
$ cat terraform_config.tf
```
```
terraform {
    backend "s3" {
        bucket = "core.198499106403.terraform-state"
        key = "kubernetes"
        region = "ap-southeast-2"
        dynamodb_table = "core.198499106403.terraform-locks"
        profile = "default"
    }
}
```

You can then move this generated file into the relevant terraform folder to make it use the correct backend.

### Creating cluster with kops

We use kops to generate our config in terraform so we can continue to use terraform to plan and deploy this. When you're ready to create the cluster config you can do

```bash
$ kops create cluster \
        --name=binder.geo-analytics.io \
        --state=s3://core.binder.kubernetes.state.store \
        --dns-zone=binder.geo-analytics.io \
        --out=. \
        --target=terraform \
        --zones ap-southeast-2a,ap-southeast-2b \
        --master-zones ap-southeast-2b \
        --node-size t2.medium \
        --master-size t2.medium
```

If the cluster has already been created and you just want to regenerate the terraform configuration, then you can do

```bash
$ kops update cluster binder.geo-analytics.io \
       --state=s3://core.binder.kubernetes.state.store \
       --target=terraform \
       --out=.
```

Then a `terraform init|plan|apply` should get you a working cluster.