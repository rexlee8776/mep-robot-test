*** Settings ***
Resource    ../environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library    REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false
Library    JSONSchemaLibrary    schemas/


*** Keywords ***
Check AppInstanceId
    [Arguments]    ${value}
    Log    Check AppInstanceId for bwInfo element
    Should be Equal    ${response['body']['bwInfo']['appInsId']}    ${value}
    Log    AppInstanceId OK


Check AllocationId
    [Arguments]    ${value}
    Log    Check AllocationId for bwInfo element
    Should be Equal    ${response['body']['bwInfo']['fixedAllocation']}    ${value}
    Log    AllocationId OK
