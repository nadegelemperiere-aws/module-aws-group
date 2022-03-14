# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2022] Technogix SARL
# All rights reserved
# -------------------------------------------------------
# Keywords to create data for module test
# -------------------------------------------------------
# Nadège LEMPERIERE, @13 november 2021
# Latest revision: 13 november 2021
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

    result = []

    result.append({})
    result[0]['name'] = 'standard'
    result[0]['data'] = {}
    result[0]['data']['Name']              = 'test-test-test'
    result[0]['data']['PermissionSetArn']  = arn
    result[0]['data']['SessionDuration']   = 'PT2H'
    result[0]['data']['RelayState']        = 'https://eu-west-1.console.aws.amazon.com/'
    result[0]['data']['InlinePolicy']      = '{\"Statement\":[{\"Action\":[\"s3:ListAllMyBuckets\"],\"Effect\":\"Allow\",\"Resource\":[\"*\"],\"Sid\":\"AllowS3Listing\"},{\"Action\":[\"s3:GetObject\"],\"Effect\":\"Allow\",\"Resource\":[\"*\"],\"Sid\":\"AllowS3Reading\"}],\"Version\":\"2012-10-17\"}'
    result[0]['data']['Tags'] = []
    result[0]['data']['Tags'].append({'Key'          : 'Version'     , 'Value' : 'test'})
    result[0]['data']['Tags'].append({'Key'          : 'Project'     , 'Value' : 'test'})
    result[0]['data']['Tags'].append({'Key'          : 'Module'      , 'Value' : 'test'})
    result[0]['data']['Tags'].append({'Key'          : 'Environment' , 'Value' : 'test'})
    result[0]['data']['Tags'].append({'Key'          : 'Owner'       , 'Value' : 'moi.moi@moi.fr'})
    result[0]['data']['Tags'].append({'Key'          : 'Name'        , 'Value' : 'test.test.test.permission.test'})

    logger.debug(dumps(result[0]))

    return result

@keyword('Load No Rights Test Data')
def load_no_rights_test_data(arn) :

    result = []
    result.append({})
    result[0]['name'] = 'no-rights'
    result[0]['data'] = {}
    result[0]['data']['Name']              = 'test-test-test'
    result[0]['data']['PermissionSetArn']  = arn
    result[0]['data']['SessionDuration']   = 'PT2H'
    result[0]['data']['RelayState']        = 'https://eu-west-1.console.aws.amazon.com/'
    result[0]['data']['InlinePolicy']      = ''
    result[0]['data']['Tags'] = []
    result[0]['data']['Tags'].append({'Key'          : 'Version'     , 'Value' : 'test'})
    result[0]['data']['Tags'].append({'Key'          : 'Project'     , 'Value' : 'test'})
    result[0]['data']['Tags'].append({'Key'          : 'Module'      , 'Value' : 'test'})
    result[0]['data']['Tags'].append({'Key'          : 'Environment' , 'Value' : 'test'})
    result[0]['data']['Tags'].append({'Key'          : 'Owner'       , 'Value' : 'moi.moi@moi.fr'})
    result[0]['data']['Tags'].append({'Key'          : 'Name'        , 'Value' : 'test.test.test.permission.test'})

    logger.debug(dumps(result[0]))

    return result
