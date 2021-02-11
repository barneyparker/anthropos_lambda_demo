MAKEFLAGS += --warn-undefined-variables --no-print-directory
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

export AWS_DEFAULT_REGION=eu-west-1

ENVNAME=global

TF_STATE_BUCKET=anthropos-terraform-state
STACK=

ifndef STACK
$(error Please set the STACK variable to your name)
endif

TF_STATE_FILE=$(ENVNAME)-$(AWS_DEFAULT_REGION)-$(STACK)

.PHONY: all clean init fmt plan apply

$(info State:  $(TF_STATE_BUCKET)/$(TF_STATE_FILE))
$(info Env:    $(ENVNAME))
$(info Region: $(AWS_DEFAULT_REGION))
$(info Stack:  $(STACK))

all: plan

clean:
	@rm -rf .terraform/terraform.tfstate*
	@rm -rf .terraform/*zip

init:
	@terraform init \
		-backend=true \
		-backend-config="bucket=${TF_STATE_BUCKET}" \
		-backend-config="key=${TF_STATE_FILE}.tfstate" \
		-get=true

fmt:
	@terraform fmt

plan: clean init fmt
	@terraform plan \
		-var-file=params/$(ENVNAME).tfvars \
		-var="envname=$(ENVNAME)" \
		-var="aws_region=$(AWS_DEFAULT_REGION)" \
		-lock=true \
		-out=".terraform/$(TF_STATE_FILE).plan"

apply:
	@terraform apply \
		-lock=true \
		.terraform/$(TF_STATE_FILE).plan

destroy: clean init
	@terraform destroy \
	  -var-file=params/$(ENVNAME).tfvars \
		-var="envname=$(ENVNAME)" \
		-var="aws_region=$(AWS_DEFAULT_REGION)"
