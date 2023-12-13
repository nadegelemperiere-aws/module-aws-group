# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Keywords to create data for module test
# -------------------------------------------------------
# Nadège LEMPERIERE, @13 november 2021
# Latest revision: 12 december 2023
# -------------------------------------------------------

# System includes
from json import load, dumps

# Robotframework includes
from robot.libraries.BuiltIn import BuiltIn, _Misc
from robot.api import logger as logger
from robot.api.deco import keyword
ROBOT = False

# ip address manipulation
from ipaddress import IPv4Network

@keyword('Load Standard Test Data')
def load_standard_test_data(arn) :

    result = {'groups' : [], 'permissions' : []}

    result['groups'].append({})
    result['groups'][0]['name'] = 'standard'
    result['groups'][0]['data'] = {}
    result['groups'][0]['data']['DisplayName'] = 'test'
    result['groups'][0]['data']['Description'] = 'test'

    result['permissions'].append({})
    result['permissions'][0]['name'] = 'standard'
    result['permissions'][0]['data'] = {}
    result['permissions'][0]['data']['Name']              = 'test-test-test'
    result['permissions'][0]['data']['PermissionSetArn']  = arn
    result['permissions'][0]['data']['SessionDuration']   = 'PT2H'
    result['permissions'][0]['data']['RelayState']        = 'https://eu-west-1.console.aws.amazon.com/'
    result['permissions'][0]['data']['InlinePolicy']      = '{\"Statement\":[{\"Action\":[\"s3:ListAllMyBuckets\"],\"Condition\":{\"StringEquals\":{\"aws:RequestedRegion\":[\"eu-west-1\"]}},\"Effect\":\"Allow\",\"Resource\":[\"*\"],\"Sid\":\"AllowS3Listing\"},{\"Action\":[\"s3:GetObject\"],\"Effect\":\"Allow\",\"Resource\":[\"*\"],\"Sid\":\"AllowS3Reading\"},{\"Condition\":{\"StringNotEquals\":{\"aws:RequestedRegion\":[\"eu-west-1\",\"us-east-1\"]}},\"Effect\":\"Deny\",\"NotAction\":[\"ec2:Describe*\",\"kms:List*\"],\"Resource\":[\"*\"],\"Sid\":\"DenyOtherRegions\"}],\"Version\":\"2012-10-17\"}'
    result['permissions'][0]['data']['Tags'] = []
    result['permissions'][0]['data']['Tags'].append({'Key'          : 'Version'     , 'Value' : 'test'})
    result['permissions'][0]['data']['Tags'].append({'Key'          : 'Project'     , 'Value' : 'test'})
    result['permissions'][0]['data']['Tags'].append({'Key'          : 'Module'      , 'Value' : 'test'})
    result['permissions'][0]['data']['Tags'].append({'Key'          : 'Environment' , 'Value' : 'test'})
    result['permissions'][0]['data']['Tags'].append({'Key'          : 'Owner'       , 'Value' : 'moi.moi@moi.fr'})
    result['permissions'][0]['data']['Tags'].append({'Key'          : 'Name'        , 'Value' : 'test.test.test.permission.test'})

    logger.debug(dumps(result))

    return result

@keyword('Load No Rights Test Data')
def load_no_rights_test_data(arn) :

    result = {'groups' : [], 'permissions' : []}

    result['groups'].append({})
    result['groups'][0]['name'] = 'standard'
    result['groups'][0]['data'] = {}
    result['groups'][0]['data']['DisplayName'] = 'test'
    result['groups'][0]['data']['Description'] = 'test'

    result['permissions'].append({})
    result['permissions'][0]['name'] = 'no-rights'
    result['permissions'][0]['data'] = {}
    result['permissions'][0]['data']['Name']              = 'test-test-test'
    result['permissions'][0]['data']['PermissionSetArn']  = arn
    result['permissions'][0]['data']['SessionDuration']   = 'PT2H'
    result['permissions'][0]['data']['RelayState']        = 'https://eu-west-1.console.aws.amazon.com/'
    result['permissions'][0]['data']['InlinePolicy']      = ''
    result['permissions'][0]['data']['Tags'] = []
    result['permissions'][0]['data']['Tags'].append({'Key'          : 'Version'     , 'Value' : 'test'})
    result['permissions'][0]['data']['Tags'].append({'Key'          : 'Project'     , 'Value' : 'test'})
    result['permissions'][0]['data']['Tags'].append({'Key'          : 'Module'      , 'Value' : 'test'})
    result['permissions'][0]['data']['Tags'].append({'Key'          : 'Environment' , 'Value' : 'test'})
    result['permissions'][0]['data']['Tags'].append({'Key'          : 'Owner'       , 'Value' : 'moi.moi@moi.fr'})
    result['permissions'][0]['data']['Tags'].append({'Key'          : 'Name'        , 'Value' : 'test.test.test.permission.test'})

    logger.debug(dumps(result))

    return result
