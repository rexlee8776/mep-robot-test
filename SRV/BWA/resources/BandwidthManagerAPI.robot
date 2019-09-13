*** Settings ***
Resource    ../environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library    REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false
Library    JSONSchemaLibrary    schemas/


*** Keywords ***
Register Bandwidth Management Service
    ...  Register a Bandwidth Management Service
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Post    /exampleAPI/bwm/v1/bw_allocations    ${REQUEST_FOR_BW_REQUIREMENTS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   bwInfo
    # Extract ETAG_VALUE
    Set Suite Variable    ${ETAG_VALUE}     ${response['status']['ETag']}
    Should Not Be Empty    ${ETAG_VALUE}
    # TODO Extract allocationId not possible, information is missing in the standard doc
    Set Suite Variable    ${ALLOCATION_ID}    ${response['body']['bwInfo']['allocationId']}
    Should Not Be Empty    ${ALLOCATION_ID}


Unregister Bandwidth Management Service
    ...  Unregister a Bandwidth Management Service
    [Arguments]    ${value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Delete    /exampleAPI/bwm/v1/bw_allocations/${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    204


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
