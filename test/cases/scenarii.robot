# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Robotframework test suite for module
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 12 december 2023
# -------------------------------------------------------


*** Settings ***
Documentation   A test case to check permission sets creation
Library         aws_iac_keywords.terraform
Library         aws_iac_keywords.keepass
Library         aws_iac_keywords.sso
Library         aws_iac_keywords.identitystore
Library         ../keywords/data.py
Library         OperatingSystem

*** Variables ***
${KEEPASS_DATABASE}                 ${vault_database}
${KEEPASS_KEY_ENV}                  ${vault_key_env}
${KEEPASS_PRINCIPAL_KEY_ENTRY}      /aws/aws-principal-access-key
${KEEPASS_ACCOUNT_ENTRY}            /aws/aws-account
${KEEPASS_IDENTITY_STORE}           /aws/aws-identity-center-store
${REGION}                           eu-west-1

*** Test Cases ***
Prepare environment
    [Documentation]            Retrieve principal credential from database and initialize python tests keywords
    ${keepass_key}             Get Environment Variable          ${KEEPASS_KEY_ENV}
    ${principal_access}        Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_PRINCIPAL_KEY_ENTRY}            username
    ${principal_secret}        Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_PRINCIPAL_KEY_ENTRY}            password
    ${account}                 Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_ACCOUNT_ENTRY}            password
    ${id}                      Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_IDENTITY_STORE}                 password
    ${TF_PARAMETERS}=          Create Dictionary   account="${ACCOUNT}"
    Initialize Terraform       ${REGION}   ${principal_access}   ${principal_secret}
    Initialize SSO             None        ${principal_access}   ${principal_secret}    ${REGION}
    Initialize Identity Store  None        ${principal_access}   ${principal_secret}    ${REGION}    ${id}
    Set Global Variable        ${TF_PARAMETERS}

Create Standard Permissions
    [Documentation]         Create SSO Group With Standard IAM Permissions
    Launch Terraform Deployment                 ${CURDIR}/../data/standard      ${TF_PARAMETERS}
    ${states}   Load Terraform States           ${CURDIR}/../data/standard
    ${specs}    Load Standard Test Data         ${states['test']['outputs']['permissions']['value']['arn']}
    Group Shall Exist And Match                 ${specs['groups']}
    Permission Set Shall Exist And Match        ${specs['permissions']}
    [Teardown]  Destroy Terraform Deployment    ${CURDIR}/../data/standard      ${TF_PARAMETERS}

Create Permissions With No Rights
    [Documentation]         Create SSO Group With No IAM Permissions
    Launch Terraform Deployment                 ${CURDIR}/../data/no-rights     ${TF_PARAMETERS}
    ${states}   Load Terraform States           ${CURDIR}/../data/no-rights
    ${specs}    Load No Rights Test Data        ${states['test']['outputs']['permissions']['value']['arn']}
    Group Shall Exist And Match                 ${specs['groups']}
    Permission Set Shall Exist And Match        ${specs['permissions']}
    [Teardown]  Destroy Terraform Deployment    ${CURDIR}/../data/no-rights     ${TF_PARAMETERS}
