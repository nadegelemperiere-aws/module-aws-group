# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2022] Technogix SARL
# All rights reserved
# -------------------------------------------------------
# Robotframework test suite for module
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 12 november 2021
# -------------------------------------------------------


*** Settings ***
Documentation   A test case to check permission sets creation
Library         technogix_iac_keywords.terraform
Library         technogix_iac_keywords.keepass
Library         technogix_iac_keywords.sso
Library         ../keywords/data.py

*** Variables ***
${KEEPASS_DATABASE}                 ${vault_database}
${KEEPASS_KEY}                      ${vault_key}
${KEEPASS_GOD_KEY_ENTRY}            /engineering-environment/aws/aws-god-access-key
${KEEPASS_ID_ENTRY}                 /engineering-environment/aws/aws-sso-sysadmin-group-id
${KEEPASS_ACCOUNT_ENTRY}            /engineering-environment/aws/aws-account
${REGION}                           eu-west-1

*** Test Cases ***
Prepare environment
    [Documentation]         Retrieve god credential from database and initialize python tests keywords
    ${god_access}           Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${KEEPASS_KEY}  ${KEEPASS_GOD_KEY_ENTRY}            username
    ${god_secret}           Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${KEEPASS_KEY}  ${KEEPASS_GOD_KEY_ENTRY}            password
    ${account}              Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${KEEPASS_KEY}  ${KEEPASS_ACCOUNT_ENTRY}            password
    ${id}                   Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${KEEPASS_KEY}  ${KEEPASS_ID_ENTRY}                 password
    ${TF_PARAMETERS}=       Create Dictionary   account="${ACCOUNT}"    id="${id}"
    Initialize Terraform    ${REGION}   ${god_access}   ${god_secret}
    Initialize SSO          None        ${god_access}   ${god_secret}    ${REGION}
    Set Global Variable     ${TF_PARAMETERS}

Create Standard Permissions
    [Documentation]         Create Standard SSO Group IAM Permissions
    Launch Terraform Deployment                 ${CURDIR}/../data/standard      ${TF_PARAMETERS}
    ${states}   Load Terraform States           ${CURDIR}/../data/standard
    ${specs}    Load Standard Test Data         ${states['test']['outputs']['permissions']['value']['arn']}
    Permission Set Shall Exist And Match        ${specs}
    [Teardown]  Destroy Terraform Deployment    ${CURDIR}/../data/standard      ${TF_PARAMETERS}

Create Permissions With No Rights
    [Documentation]         Create SSO Group With No IAM Permissions
    Launch Terraform Deployment                 ${CURDIR}/../data/no-rights     ${TF_PARAMETERS}
    ${states}   Load Terraform States           ${CURDIR}/../data/no-rights
    ${specs}    Load No Rights Test Data        ${states['test']['outputs']['permissions']['value']['arn']}
    Permission Set Shall Exist And Match        ${specs}
    [Teardown]  Destroy Terraform Deployment    ${CURDIR}/../data/no-rights     ${TF_PARAMETERS}
