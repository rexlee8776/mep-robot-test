''[Documentation]   robot --outputdir ../../outputs ./PlatBandwidthManager.robot
...    Test Suite to validate Bandwidth Management API (BWA) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../pics.txt
Resource    ../../GenericKeywords.robot
Resource    resources/BandwidthManagerAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false



*** Test Cases ***
Request the list of configured bandwidth allocations
    [Documentation]   TC_MEC_SRV_BWA_001_OK
    ...  Check that the IUT responds with the list of configured bandwidth allocations when queried by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.4.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Get the list of configured bandwidth allocations    ${APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   bwInfo
    Check AppInstanceId    ${APP_INSTANCE_ID}


Request the list of configured bandwidth allocations with wrong app instance id
    [Documentation]   TC_MEC_SRV_BWA_001_BR
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.4.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Get the list of configured bandwidth allocations    ${NON_EXISTENT_APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    400
    Check ProblemDetails    400


Request for the requested bandwidth requirements
    [Documentation]   TC_MEC_SRV_BWA_002_OK
    ...  Check that the IUT responds with a registration and initialisation approval for the requested bandwidth requirements sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.4.3.4
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Registration for bandwidth requirements    ${APP_INSTANCE_ID}    ${REQUEST_FOR_BW_REQUIREMENTS}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   bwInfo
    Check AppInstanceId    ${APP_INSTANCE_ID}


Request for the requested bandwidth requirements using wrong parameters
    [Documentation]   TC_MEC_SRV_BWA_002_BR
    ...  Check that the IUT responds with a registration and initialisation approval for the requested bandwidth requirements sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.4.3.4
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Registration for bandwidth requirements    ${APP_INSTANCE_ID}    ${REQUEST_FOR_BW_REQUIREMENTS_BR}
    Check HTTP Response Status Code Is    400
    Check ProblemDetails    400


Request for a bandwidth allocation
    [Documentation]   TC_MEC_SRV_BWA_003_OK
    ...  Check that the IUT responds with the configured bandwidth allocation when queried by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Get a bandwidth allocation    ${ALLOCATION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   bwInfo
    Check AppInstanceId    ${APP_INSTANCE_ID}


Request for a bandwidth allocation using wrong parameters
    [Documentation]   TC_MEC_SRV_BWA_003_NF
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Get a bandwidth allocation    ${NON_EXISTENT_ALLOCATION_ID}
    Check HTTP Response Status Code Is    404
    Check ProblemDetails    404


Updates the requested bandwidth requirements
    [Documentation]   TC_MEC_SRV_BWA_004_OK
    ...  Check that the IUT updates the requested bandwidth requirements when commanded by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.2
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Update a bandwidth allocation    ${ALLOCATION_ID}    ${REQUEST_FOR_BW_REQUIREMENTS}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   bwInfo
    Check AppInstanceId    ${APP_INSTANCE_ID}
    Check Allocation    ${ALLOCATION_ID}


    [Documentation]   TC_MEC_SRV_BWA_004_BR
    Updates the requested bandwidth requirements using wrong allocationDirection
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.2
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Update a bandwidth allocation    ${ALLOCATION_ID}    ${REQUEST_FOR_BW_REQUIREMENTS_ID}
    Check HTTP Response Status Code Is    400
    Check ProblemDetails    400


Updates the requested bandwidth requirements using wrong allocationId
    [Documentation]   TC_MEC_SRV_BWA_004_NF
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.2
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Update a bandwidth allocation    ${NOT_EXISTENT_ALLOCATION_ID}    ${REQUEST_FOR_BW_REQUIREMENTS}
    Check HTTP Response Status Code Is    404
    Check ProblemDetails    404


Updates the requested bandwidth requirements using wrong parameters
    [Documentation]   TC_MEC_SRV_BWA_004_PF
    ...  Check that the IUT responds with an error when a request sent by a MEC Application doesn't comply with a required condition
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.2
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    # TODO Application doesn't comply with a required condition???
    Update a bandwidth allocation    ${ALLOCATION_ID}    ${REQUEST_FOR_BW_REQUIREMENTS}
    Check HTTP Response Status Code Is    412
    Check ProblemDetails    412


*** Keywords ***
    Get the list of configured bandwidth allocations
        [Arguments]    ${app_instance_id}
        Should Be True    ${PIC_MEC_PLAT} == 1
        Should Be True    ${PIC_SERVICES} == 1
        Set Headers    {"Accept":"application/json"}
        Set Headers    {"Content-Type":"application/json"}
        Set Headers    {"Authorization":"${TOKEN}"}
        Set Headers    {"Content-Length":"0"}
        Get    /exampleAPI/bwm/v1/bw_allocations?app_instance_id=${app_instance_id}
        ${output}=    Output    response
        Set Suite Variable    ${response}    ${output}


    Registration for bandwidth requirements
        [Arguments]    ${app_instance_id}    ${content}
        Should Be True    ${PIC_MEC_PLAT} == 1
        Should Be True    ${PIC_SERVICES} == 1
        Set Headers    {"Accept":"application/json"}
        Set Headers    {"Content-Type":"application/json"}
        Set Headers    {"Authorization":"${TOKEN}"}
        Set Headers    {"Content-Length":"0"}
        log    ${content}
        Put    /exampleAPI/bwm/v1/bw_allocations?app_instance_id=${APP_INSTANCE_ID}    ${content}
        ${output}=    Output    response
        Set Suite Variable    ${response}    ${output}


    Get a bandwidth allocation
        [Arguments]    ${allocation_id}
        Should Be True    ${PIC_MEC_PLAT} == 1
        Should Be True    ${PIC_SERVICES} == 1
        Set Headers    {"Accept":"application/json"}
        Set Headers    {"Content-Type":"application/json"}
        Set Headers    {"Authorization":"${TOKEN}"}
        Set Headers    {"Content-Length":"0"}
        Get    /exampleAPI/bwm/v1/bw_allocations?allocation_id=${allocation_id}
        ${output}=    Output    response
        Set Suite Variable    ${response}    ${output}


    Update a bandwidth allocation
        [Arguments]    ${allocation_id}    ${content}
        Should Be True    ${PIC_MEC_PLAT} == 1
        Should Be True    ${PIC_SERVICES} == 1
        Set Headers    {"Accept":"application/json"}
        Set Headers    {"Content-Type":"application/json"}
        Set Headers    {"Authorization":"${TOKEN}"}
        Set Headers    {"Content-Length":"0"}
        Put    /exampleAPI/bwm/v1/bw_allocations?allocation_id=${allocation_id}    ${content}
        ${output}=    Output    response
        Set Suite Variable    ${response}    ${output}
