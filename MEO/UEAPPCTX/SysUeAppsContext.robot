''[Documentation]   robot --outputdir ../../outputs ./SysUeAppContext.robot
...    Test Suite to validate Bandwidth Management API (APPCTX) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../pics.txt
Resource    ../../GenericKeywords.robot
Resource    resources/UeAppsContextAPI.robot
Library     String
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false


*** Test Cases ***
Creation of the application context
    [Documentation]   TC_MEC_MEO_UEAPPCTX_001_OK
    ...  Check that the IUT acknowledges the creation of the application context when requested by an UE Application
    ...  Reference ETSI GS MEC 016 V1.1.1, clause 7.4.3.4
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/AppContext
    Create application context    ${CREATE_APP_CTX}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   AppContext
    Should Be True    ${response['body']['appContext']['appInfo']['appName']} == ${APP_NAME}
    # Postamble
    Delete an application context    ${APP_CTX_ID}


Creation of the application context with wrong parameters
    [Documentation]   TC_MEC_MEO_UEAPPCTX_001_BR
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference ETSI GS MEC 016 V1.1.1, clause 7.4.3.4
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/AppContext
    Create application context    ${CREATE_APP_CTX_BR}
    Check HTTP Response Status Code Is    400
    Check ProblemDetails    400


Update of the application context
    [Documentation]   TC_MEC_MEO_UEAPPCTX_002_OK
    ...  Check that the IUT updates the application callback reference when commanded by an UE Application
    ...  Reference ETSI GS MEC 016 V1.1.1, clause 7.5.3.2
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/AppContext
    # Preamble
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Create an application context
    # Test Body
    ${CREATE_APP_CTX}=    Set Variable  ${CALLBACK_REFERENCE_1}
    Update application context    ${APP_CTX_ID}    ${CREATE_APP_CTX}
    Check HTTP Response Status Code Is    204
    Check HTTP Response Body Json Schema Is   AppContext
    Should Be True    ${response['body']['appContext']['callbackReference']} == ${CALLBACK_REFERENCE_1}
    # Postamble
    Delete an application context    ${APP_CTX_ID}


Update of the application context with wrong parameters
    [Documentation]   TC_MEC_MEO_UEAPPCTX_002_BR
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference ETSI GS MEC 016 V1.1.1, clause 7.5.3.2
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/AppContext
    # Preamble
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Create an application context
    # Test Body
    ${CREATE_APP_CTX}=     Set Variable  '' # Empty string
    Update application context    ${APP_CTX_ID}    ${CREATE_APP_CTX}
    Check HTTP Response Status Code Is    400
    Check ProblemDetails    400
    # Postamble
    Delete an application context    ${APP_CTX_ID}


Update of the application context with unknown URI
    [Documentation]   TC_MEC_MEO_UEAPPCTX_002_NF
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  Reference ETSI GS MEC 016 V1.1.1, clause 7.5.3.2
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/AppContext
    # Preamble
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Create an application context
    # Test Body
    ${CREATE_APP_CTX}=    Set Variable    ${CALLBACK_REFERENCE_1}
    Update application context    ${NON_EXISTENT_APP_CTX_ID}    ${CREATE_APP_CTX}
    Check HTTP Response Status Code Is    404
    Check ProblemDetails    404
    # Postamble
    Delete an application context    ${APP_CTX_ID}


Delete of the application context
    [Documentation]   TC_MEC_MEO_UEAPPCTX_003_OK
    ...  Check that the IUT deletes the application context when commanded by an UE Application
    ...  Reference ETSI GS MEC 016 V1.1.1, clause 7.5.3.5
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/AppContext
    # Preamble
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Create an application context
    # Test Body
    Delete application context    ${APP_CTX_ID}
    Check HTTP Response Status Code Is    204


Delete of the application context with non esistent APP CTX ID
    [Documentation]   TC_MEC_MEO_UEAPPCTX_003_NF
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  Reference ETSI GS MEC 016 V1.1.1, clause 7.5.3.5
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/AppContext
    # Preamble
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    # AppCtx not created!
    # Test Body
    Delete application context    ${APP_CTX_ID}
    Check HTTP Response Status Code Is    404
    Check ProblemDetails    404


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


Delete application context
    [Arguments]    ${context_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Delete    /exampleAPI/mx2/v2/app_contexts/${context_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
