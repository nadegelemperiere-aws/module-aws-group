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

output "name" {
    value = aws_ssoadmin_permission_set.permission_set.name
}

output "instance_arn" {
    value = aws_ssoadmin_permission_set.permission_set.instance_arn
}

output "arn" {
    value = aws_ssoadmin_permission_set.permission_set.arn
}