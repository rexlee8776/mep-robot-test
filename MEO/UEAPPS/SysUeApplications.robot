''[Documentation]   robot --outputdir ../../outputs ./SysUeApplications.robot
...    Test Suite to validate Bandwidth Management API (BWA) operations.

*** Settings ***
Resource    ../UEAPPCTX/environment/variables.txt
Resource    ../../pics.txt
Resource    ../../GenericKeywords.robot
Resource    ../UEAPPCTX/resources/UeAppContextAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false



*** Test Cases ***
Get the list of the application contexts
    [Documentation]   TC_MEC_MEO_UEAPPS_001_OK
    ...  Check that the IUT responds with the list of user applications available when requested by an UE Application
    ...  Reference ETSI GS MEC 016 V1.1.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/ApplicationList
    # Preamble
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Create an application context
    # Test Body
    Retrieve the application contexts list    ${APP_NAME}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   AppInfo
    Should Be True    ${response['body']['appInfo']['appInfo'][0]['appName']} == ${APP_NAME}
    # Postamble
    Delete an application context    ${APP_CTX_ID}


Get the list of the application contexts with wrong parameter
    [Documentation]   TC_MEC_MEO_UEAPPS_001_BR
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference ETSI GS MEC 016 V1.1.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/ApplicationList
    # Preamble
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Create an application context
    # Test Body
    Retrieve the application contexts list with serviceCont   ${SERVICE_CONT_BR}
    Check HTTP Response Status Code Is    400
    Check ProblemDetails    400
    # Postamble
    Delete an application context    ${APP_CTX_ID}


Get the list of the application contexts with wrong parameter
    [Documentation]   TC_MEC_MEO_UEAPPS_001_NF
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  Reference ETSI GS MEC 016 V1.1.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/ApplicationList
    # Preamble
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    # AppInfo not created
    # Test Body
    Retrieve the application contexts list   ${APP_NAME}
    Check HTTP Response Status Code Is    404
    Check ProblemDetails    404


*** Keywords ***
Retrieve the application contexts list
    [Arguments]    ${app_name}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Post    /exampleAPI/mx2/v2/app_list?appName=${app_name}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Retrieve the application contexts list with serviceCont
    [Arguments]    ${service_cont}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Post    /exampleAPI/mx2/v2/app_list?serviceCont=${service_cont}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
