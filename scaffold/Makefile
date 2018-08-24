.DEFAULT_GOAL := help
.PHONY: help plan deploy clean remote_state

# Constant variables
SHELL := /bin/bash
OWNER := core
NAME := scaffold
AWS_PROFILE := default
AWS_REGION := ap-southeast-2
ENVIRONMENT := develop
TERRAFORM_BIN := /usr/local/bin/terraform

# Generated variables
timestamp := $(shell /bin/date +%F-%H:%M:%S)
root_dir := $(shell /bin/pwd)
script_dir := ../scripts
aws_account_id := $(shell export AWS_PROFILE=$(AWS_PROFILE) && aws sts get-caller-identity --query Account --output text)

# Environment variables
-include variables.mk

help:
	@echo "Builds the calibrator scaffold infrastructure"
	@
	@echo "We basically expose the terraform commands but with various useful environment variables"
	@echo "set so you don't have to (e.g. AWS_PROFILE, AWS_REGION etc)"
	@echo ""
	@echo "Targets:"
	@echo "  - environment  Configures & checks the environment for building and deploying"
	@echo "  - init         Initialize the terraform modules"
	@echo "  - plan         Builds a new terraform plan file"
	@echo "  - apply        Commits the plan against the infrastructure"
	@echo "  - destroy      Tear down all managed infrastructure"
	@echo "  - clean        Cleans up build artifacts (also removes build/deploy state)"
	@echo "  - help         This message"
	@echo ""

clean: clean_environment clean_terraform

## ENVIONMENT
clean_environment:
	rm -f .variables.sh variables.mk

variables.mk: .variables.sh
	@sed 's/"//g ; s/=/:=/' < $< > $@

.variables.sh:
	(export AWS_PROFILE=$(AWS_PROFILE); python3 "$(script_dir)/get_credentials.py" > .variables.sh)

environment: variables.mk
	@printf "Checking for required tools\n - terraform ... "
	@hash $(TERRAFORM_BIN) > /dev/null 2>&1 || \
		(printf "not found! Install terraform (you can use 'scripts/hashicorp.sh install terraform' or your package manager)"; exit 1)
	@printf "ok\nChecking environment variables are set ... "
	@test -n "\$AWS_ACCESS_KEY_ID" || \
		(printf "AWS_ACCESS_KEY_ID env not set, make sure you have done `aws configure` and run \`make credentials\`"; exit 1)
	@test -n "\$AWS_SECRET_ACCESS_KEY" || \
		(printf "AWS_SECRET_ACCESS_KEY env not set, run \`make credentials\`"; exit 1)
	@printf "ok\nEnvironment all set to go!\n"

## TERRAFORM REMOTE STATE CONFIG
initialize_state:
	bash "$(script_dir)/remote_state.sh" create

terraform_config.tf: variables.mk
	bash "$(script_dir)/remote_state.sh" config $(NAME)

## TERRAFORM COMMANDS
init: variables.mk terraform_config.tf
	$(TERRAFORM_BIN) init "$(root_dir)"

.terraform:
	@make init

plan: variables.mk .terraform
	$(TERRAFORM_BIN) plan \
		-var="aws_access_key=$(AWS_ACCESS_KEY_ID)" \
		-var="aws_secret_key=$(AWS_SECRET_ACCESS_KEY)" \
		-var="aws_account_id=$(aws_account_id)" \
		-var="aws_region=$(AWS_REGION)" \
		-var="name=binder" \
		-out="$(root_dir)/$(ENVIRONMENT)-$(AWS_REGION)-$(NAME).tfplan" \
		"$(root_dir)"

refresh: variables.mk
	$(TERRAFORM_BIN) refresh \
		-var="aws_access_key=$(AWS_ACCESS_KEY_ID)" \
		-var="aws_secret_key=$(AWS_SECRET_ACCESS_KEY)" \
		-var="aws_account_id=$(aws_account_id)" \
		-var="aws_region=$(AWS_REGION)" \
		-var="name=binder" \
		"$(root_dir)"

$(ENVIRONMENT)-$(AWS_REGION)-$(NAME).tfplan:
	make plan

deploy: $(ENVIRONMENT)-$(AWS_REGION)-$(NAME).tfplan
	$(TERRAFORM_BIN) apply $(ENVIRONMENT)-$(AWS_REGION)-$(NAME).tfplan

destroy:
	$(TERRAFORM_BIN) destroy \
		-var="aws_access_key=$(AWS_ACCESS_KEY_ID)" \
		-var="aws_secret_key=$(AWS_SECRET_ACCESS_KEY)" \
		-var="aws_account_id=$(aws_account_id)" \
		-var="aws_region=$(AWS_REGION)" \
		-var="name=binder" \
		"$(root_dir)"

clean_terraform:
	rm -rf .terraform
	rm -f $(ENVIRONMENT)-$(AWS_REGION)-$(NAME).{tfstate,tfplan}*