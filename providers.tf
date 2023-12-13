# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Module to deploy an AWS SSO group
# -------------------------------------------------------
# Nadège LEMPERIERE, @20 november 2023
# Latest revision: 20 november 2023
# ------------------------------------------------------

terraform {
  required_version = ">= 1.6.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.26.0"
    }
  }
}