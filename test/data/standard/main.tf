# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2022] Technogix SARL
# All rights reserved
# -------------------------------------------------------
# Simple deployment for permissions testing
# -------------------------------------------------------
# Nadège LEMPERIERE, @20 november 2021
# Latest revision: 20 november 2021
# -------------------------------------------------------

# -------------------------------------------------------
# Create permissions using the current module
# -------------------------------------------------------
module "group" {
    source      = "../../../"
    email 		= "moi.moi@moi.fr"
	project 	= "test"
	environment = "test"
	module 		= "test"
	git_version = "test"
    account     = var.account
    group       = {
        name        = "test"
        id          = var.id
        console     = "https://eu-west-1.console.aws.amazon.com/"
    }
    rights      = [
        {
            description = "AllowS3Listing"
            actions     = ["s3:ListAllMyBuckets"]
            resources   = ["*"]
			condition   = "{ \"StringEquals\" : { \"aws:RequestedRegion\" : [ \"${var.region}\" ] } }"
        },
		{
            description = "AllowS3Reading"
            actions     = ["s3:GetObject"]
            resources   = ["*"]
			condition   = "{ \"StringEquals\" : { \"aws:RequestedRegion\" : [ \"${var.region}\" ] } }"
        }
    ]
}

# -------------------------------------------------------
# Terraform configuration
# -------------------------------------------------------
provider "aws" {
	region		= "${var.region}"
	access_key 	= "${var.access_key}"
	secret_key	= "${var.secret_key}"
}

terraform {
	required_version = ">=1.0.8"
	backend "local"	{
		path="terraform.tfstate"
	}
}

# -------------------------------------------------------
# AWS configuration for this deployment
# -------------------------------------------------------
variable "region" {
	type    = string
}
variable "account" {
	type    = string
}

# -------------------------------------------------------
# AWS credentials
# -------------------------------------------------------
variable "access_key" {
	type    	= string
	sensitive 	= true
}
variable "secret_key" {
	type    	= string
	sensitive 	= true
}

# -------------------------------------------------------
# SSO group identifier
# -------------------------------------------------------
variable "id" {
	type 		= string
}

# -------------------------------------------------------
# Test outputs
# -------------------------------------------------------
output "permissions" {
	value = {
		name          = module.group.name
		instance_arn  = module.group.instance_arn
		arn           = module.group.arn
	}
}