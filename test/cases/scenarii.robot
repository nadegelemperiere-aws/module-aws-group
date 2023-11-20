# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Robotframework test suite for module
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 19 november 2023
# -------------------------------------------------------


*** Settings ***
Documentation   A test case to check permission sets creation
Library         aws_iac_keywords.terraform
Library         aws_iac_keywords.keepass
Library         aws_iac_keywords.sso
Library         ../keywords/data.py
Library         OperatingSystem

*** Variables ***
${KEEPASS_DATABASE}                 ${vault_database}
${KEEPASS_KEY_ENV}                  ${vault_key_env}
${KEEPASS_PRINCIPAL_KEY_ENTRY}      /aws/aws-principal-access-key
${KEEPASS_ID_ENTRY}                 /aws/aws-sso-sysadmin-group-id
${KEEPASS_ACCOUNT_ENTRY}            /aws/aws-account
${REGION}                           eu-west-1

*** Test Cases ***
Prepare environment
    [Documentation]         Retrieve principal credential from database and initialize python tests keywords
    ${keepass_key}          Get Environment Variable          ${KEEPASS_KEY_ENV}
    ${principal_access}     Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_PRINCIPAL_KEY_ENTRY}            username
    ${principal_secret}     Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_PRINCIPAL_KEY_ENTRY}            password
    ${account}              Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_ACCOUNT_ENTRY}            password
    ${id}                   Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_ID_ENTRY}                 password
    ${TF_PARAMETERS}=       Create Dictionary   account="${ACCOUNT}"    id="${id}"
    Initialize Terraform    ${REGION}   ${principal_access}   ${principal_secret}
    Initialize SSO          None        ${principal_access}   ${principal_secret}    ${REGION}
    Set Global Variable     ${TF_PARAMETERS}

Create Standard Permissions
    [Documentation]         Create Standard SSO Group IAM Permissions
    Launch Terraform Deployment                 ${CURDIR}/../data/standard      ${TF_PARAMETERS}
    ${states}   Load Terraform States           ${CURDIR}/../data/standard
    ${specs}    Load Standard Test Data         ${states['test']['outputs']['permissions']['value']['arn']}
    Permission Set Shall Exist And Match        ${specs}
    [Teardown]  Destroy Terraform Deployment    ${CURDIR}/../data/standard      ${TF_PARAMETERS}

#Create Permissions With No Rights
#    [Documentation]         Create SSO Group With No IAM Permissions
#    Launch Terraform Deployment                 ${CURDIR}/../data/no-rights     ${TF_PARAMETERS}
#    ${states}   Load Terraform States           ${CURDIR}/../data/no-rights
#    ${specs}    Load No Rights Test Data        ${states['test']['outputs']['permissions']['value']['arn']}
#    Permission Set Shall Exist And Match        ${specs}
#    [Teardown]  Destroy Terraform Deployment    ${CURDIR}/../data/no-rights     ${TF_PARAMETERS}
