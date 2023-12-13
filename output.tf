# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Module to deploy an SSO group
# -------------------------------------------------------
# Nadège LEMPERIERE, @14 november 2021
# Latest revision: 12 december 2023
# -------------------------------------------------------

output "name" {
    value = aws_identitystore_group.group.name
}

output "id" {
    value = aws_identitystore_group.group.group_id
}

output "permissions" {
    value = aws_ssoadmin_permission_set.permission_set.name
}

output "instance_arn" {
    value = aws_ssoadmin_permission_set.permission_set.instance_arn
}

output "arn" {
    value = aws_ssoadmin_permission_set.permission_set.arn
}

