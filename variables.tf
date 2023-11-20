# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Module to deploy the initial permissions associated to
# an AWS SSO account
# -------------------------------------------------------
# Nadège LEMPERIERE, @14 november 2021
# Latest revision: 19 november 2023
# -------------------------------------------------------


# -------------------------------------------------------
# Contact e-mail for this deployment
# -------------------------------------------------------
variable "email" {
	type 	 = string
	nullable = false
}

# -------------------------------------------------------
# Environment for this deployment (prod, preprod, ...)
# -------------------------------------------------------
variable "environment" {
	type 	 = string
	nullable = false
}

# -------------------------------------------------------
# Topic context for this deployment
# -------------------------------------------------------
variable "project" {
	type     = string
	nullable = false
}
variable "module" {
	type 	 = string
	nullable = false
}

# -------------------------------------------------------
# Solution version
# -------------------------------------------------------
variable "git_version" {
	type     = string
	nullable = false
	default  = "unmanaged"
}

# -------------------------------------------------------
# AWS account in which the permission shall be given
# -------------------------------------------------------
variable "account" {
	type = string
	nullable = false
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
		effect		= string,
		actions 	= optional(list(string))
		notactions 	= optional(list(string))
		resources 	= list(string)
		condition   = optional(string)
	}))
	default  = []
	nullable = false
}

# --------------------------------------------------------
# Initial set of managed policies to give to user
# --------------------------------------------------------
variable "managed" {
	type     = list(string)
	nullable = false
	default  = []
}