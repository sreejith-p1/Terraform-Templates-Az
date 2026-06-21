# Makefile for Terraform operations

.PHONY: help init validate plan apply destroy fmt clean

ENV ?= dev

help:
	@echo "Terraform Makefile Commands"
	@echo "============================"
	@echo ""
	@echo "Usage: make [command] ENV=<dev|uat|prod>"
	@echo ""
	@echo "Commands:"
	@echo "  init       - Initialize Terraform (requires ENV parameter)"
	@echo "  validate   - Validate Terraform configuration"
	@echo "  fmt        - Format Terraform files"
	@echo "  plan       - Plan infrastructure changes (requires ENV parameter)"
	@echo "  apply      - Apply infrastructure changes (requires ENV parameter)"
	@echo "  destroy    - Destroy infrastructure (requires ENV parameter)"
	@echo "  clean      - Clean Terraform cache"
	@echo ""
	@echo "Examples:"
	@echo "  make init ENV=dev"
	@echo "  make plan ENV=prod"
	@echo "  make apply ENV=uat"

init:
	@if [ -z "$(ENV)" ]; then echo "ERROR: ENV parameter required. Usage: make init ENV=<dev|uat|prod>"; exit 1; fi
	@echo "Initializing Terraform for $(ENV)..."
	terraform init -backend-config=environments/$(ENV)/backend.tfvars

validate:
	@echo "Validating Terraform configuration..."
	terraform validate

fmt:
	@echo "Formatting Terraform files..."
	terraform fmt -recursive

plan:
	@if [ -z "$(ENV)" ]; then echo "ERROR: ENV parameter required. Usage: make plan ENV=<dev|uat|prod>"; exit 1; fi
	@echo "Planning infrastructure changes for $(ENV)..."
	terraform plan -var-file=environments/$(ENV)/variables.tfvars -out=tfplan-$(ENV)

apply:
	@if [ -z "$(ENV)" ]; then echo "ERROR: ENV parameter required. Usage: make apply ENV=<dev|uat|prod>"; exit 1; fi
	@echo "Applying infrastructure changes for $(ENV)..."
	terraform apply tfplan-$(ENV)

destroy:
	@if [ -z "$(ENV)" ]; then echo "ERROR: ENV parameter required. Usage: make destroy ENV=<dev|uat|prod>"; exit 1; fi
	@echo "WARNING: This will destroy all infrastructure for $(ENV)!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		terraform destroy -var-file=environments/$(ENV)/variables.tfvars; \
	fi

clean:
	@echo "Cleaning Terraform cache..."
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f tfplan-*
	@echo "Clean complete"
