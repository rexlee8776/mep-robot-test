*** Settings ***
Resource    environment/variables.txt
Resource    ../../GenericKeywords.robot
Library     REST    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}    ssl_verify=false
Library     BuiltIn
Library     OperatingSystem


*** Test Cases ***
Request access to a generic resource not using token
    [Documentation]    TP_MEC_MEX_ANY_001_NT
    ...    Check that a MEC API provider responds with an error when it 
    ...    receives a request without token
    ...    ETSI GS MEC 009 1.1.1, clause 6.16.1
    [Tags]    GENERIC_TESTS    INCLUDE_UNDEFINED_SCHEMAS
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}


Request access to a generic resource using an invalid token
    [Documentation]    TP_MEC_MEX_ANY_001_WT
    ...    Check that a MEC API provider responds with an error 
    ...    when it receives a request with a wrong token
    ...    ETSI GS MEC 009 1.1.1, clause 6.16.1
    [Tags]    GENERIC_TESTS    INCLUDE_UNDEFINED_SCHEMAS
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${INVALID_TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_packages
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}
