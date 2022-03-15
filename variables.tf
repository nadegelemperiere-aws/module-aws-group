# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2022] Technogix SARL
# All rights reserved
# -------------------------------------------------------
# Module to deploy the initial permissions associated to
# an AWS SSO account
# -------------------------------------------------------
# Nadège LEMPERIERE, @14 november 2021
# Latest revision: 14 november 2021
# -------------------------------------------------------

# -------------------------------------------------------
# Contact e-mail for this deployment
# -------------------------------------------------------
variable "email" {
	type 	= string
}

# -------------------------------------------------------
# Environment for this deployment (prod, preprod, ...)
# -------------------------------------------------------
variable "environment" {
	type 	= string
}

# -------------------------------------------------------
# Topic context for this deployment
# -------------------------------------------------------
variable "project" {
	type    = string
}
variable "module" {
	type 	= string
}

# -------------------------------------------------------
# Solution version
# -------------------------------------------------------
variable "git_version" {
	type    = string
	default = "unmanaged"
}

# -------------------------------------------------------
# AWS account in which the permission shall be given
# -------------------------------------------------------
variable "account" {
	type = string
}

# --------------------------------------------------------
# SSO group description
# --------------------------------------------------------
variable "group" {
	type = object({
        name 	= string,
		id 		= string,
		console = string
    })
}

# --------------------------------------------------------
# Initial set of rights to give to user (can be overloaded
# afterwards if needed)
# --------------------------------------------------------
variable "rights" {
	type = list(object({
		description = string,
		actions 	= list(string)
		resources 	= list(string)
		condition   = string
	}))
	default = []
}

# --------------------------------------------------------
# Initial set of managed policies to give to user (can be
# overloaded)
# --------------------------------------------------------
variable "managed" {
	type = list(string)
	default = []
}
