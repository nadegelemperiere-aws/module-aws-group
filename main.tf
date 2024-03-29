# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Module to deploy an AWS SSO group
# -------------------------------------------------------
# Nadège LEMPERIERE, @14 november 2021
# Latest revision: 12 december 2023
# -------------------------------------------------------

data "aws_ssoadmin_instances" "topic_sso_instance" {}

# -------------------------------------------------------
# Create sso group
# -------------------------------------------------------
resource "aws_identitystore_group" "group" {

	display_name      = "${var.project}-${var.environment}-${var.name}"
  	description       = var.description
  	identity_store_id = tolist(data.aws_ssoadmin_instances.topic_sso_instance.identity_store_ids)[0]

}

# -------------------------------------------------------
# Create permission
# -------------------------------------------------------
resource "aws_ssoadmin_permission_set" "permission_set" {

	name                = "${var.project}-${var.environment}-${var.name}"
	description         = "${var.name} access permission"
	instance_arn        = tolist(data.aws_ssoadmin_instances.topic_sso_instance.arns)[0]
	relay_state         = var.console
	session_duration    = "PT2H"

	tags = {
		Name           	= "${var.project}.${var.environment}.${var.module}.permission.${var.name}"
		Environment     = var.environment
		Owner   		= var.email
		Project   		= var.project
		Version 		= var.git_version
		Module  		= var.module
	}
}

# -------------------------------------------------------
# Set permission policy to sso group
# -------------------------------------------------------
resource "aws_ssoadmin_account_assignment" "permission_set_assignment" {

    depends_on = [aws_ssoadmin_permission_set.permission_set]

   	instance_arn        = aws_ssoadmin_permission_set.permission_set.instance_arn
    permission_set_arn  = aws_ssoadmin_permission_set.permission_set.arn

    principal_id        = aws_identitystore_group.group.group_id
    principal_type      = "GROUP"

    target_id           = var.account
    target_type         = "AWS_ACCOUNT"
}


# -------------------------------------------------------
# Set permission policy for user
# -------------------------------------------------------
locals {
	statements = concat([
		for i,right in var.rights :
		{
			Sid 		= right.description
			Effect 		= right.effect
			Action 		= right.actions
			Resource 	= right.resources
			Condition   = jsondecode(right.condition)
		} if right.condition != null && right.actions != null
	],
	[
		for i,right in var.rights :
		{
			Sid 		= right.description
			Effect 		= right.effect
			Action 		= right.actions
			Resource 	= right.resources
		} if right.condition == null && right.actions != null
	],
	[
		for i,right in var.rights :
		{
			Sid 		= right.description
			Effect 		= right.effect
			NotAction 	= right.notactions
			Resource 	= right.resources
			Condition   = jsondecode(right.condition)
		} if right.condition != null && right.notactions != null
	],
	[
		for i,right in var.rights :
		{
			Sid 		= right.description
			Effect 		= right.effect
			NotAction 	= right.actions
			Resource 	= right.resources
		} if right.condition == null && right.notactions != null
	])
}

# -------------------------------------------------------
# Set inline policy
# -------------------------------------------------------
resource "aws_ssoadmin_permission_set_inline_policy" "rights" {

    count 			= length(local.statements) != 0 ? 1 : 0
    inline_policy   = jsonencode({
        Version 	= "2012-10-17"
        Statement 	= local.statements
    })
    instance_arn       = aws_ssoadmin_permission_set.permission_set.instance_arn
    permission_set_arn = aws_ssoadmin_permission_set.permission_set.arn
}

# -------------------------------------------------------
# Set managed policies
# -------------------------------------------------------
resource "aws_ssoadmin_managed_policy_attachment" "managed" {

	count = length(var.managed)

  	instance_arn       = aws_ssoadmin_permission_set.permission_set.instance_arn
  	managed_policy_arn = var.managed[count.index]
  	permission_set_arn = aws_ssoadmin_permission_set.permission_set.arn
}
