''[Documentation]   robot --outputdir ../../outputs ./PlatBandwidthManager.robot
...    Test Suite to validate Bandwidth Management API (BWA) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../pics.txt
Resource    ../../GenericKeywords.robot
Resource    resources/UEAppInterfaceAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false



*** Test Cases ***
Creation of the application context
    [Documentation]   TC_MEC_MEO_UEAPPCTX_001_OK
    ...  Check that the IUT acknowledges the creation of the application context when requested by an UE Application
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.4.3.4
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/AppContext
    Create application context    ${CREATE_APP_CTX}
    Check HTTP Response Status Code Is    20
    Check HTTP Response Body Json Schema Is   AppContext
    Should Be True    ${response['body']['appContext']['appInfo']['appName']} == ${APP_NAME}


Creation of the application context with wrong parameters
    [Documentation]   TC_MEC_MEO_UEAPPCTX_001_BR
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.4.3.4
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/AppContext
    Create application context    ${CREATE_APP_CTX}
    Check HTTP Response Status Code Is    400
    Check ProblemDetails    400


Update of the application context
    [Documentation]   TC_MEC_MEO_UEAPPCTX_002_OK
    ...  Check that the IUT updates the application callback reference when commanded by an UE Application
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.5.3.2
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/AppContext
    # Preamble
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Create an application context
    # Test Body
    ${CREATE_APP_CTX['callbackReference']}=    ${CALLBACK_REFERENCE_1}
    Update application context    ${CREATE_APP_CTX}
    Check HTTP Response Status Code Is    204
    Check HTTP Response Body Json Schema Is   AppContext
    Should Be True    ${response['body']['appContext']['callbackReference']} == ${CALLBACK_REFERENCE_1}


Update of the application context with wrong parameters
    [Documentation]   TC_MEC_MEO_UEAPPCTX_002_BR
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.5.3.2
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/AppContext
    # Preamble
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Create an application context
    # Test Body
    ${CREATE_APP_CTX['callbackReference']}=    '' # Empty string
    Update application context    ${CREATE_APP_CTX}
    Check HTTP Response Status Code Is    400
    Check ProblemDetails    400


*** Keywords ***
Create application context
    [Arguments]    ${content}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Post    /exampleAPI/mx2/v2/app_contexts    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Update application context
    [Arguments]    ${context_id}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Put    /exampleAPI/mx2/v2/app_contexts/${context_id}    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
