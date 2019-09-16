*** Settings ***
Resource    ../environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library    REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false
Library    JSONSchemaLibrary    schemas/


*** Keywords ***
Create an application context
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Post    /exampleAPI/mx2/v2/app_contexts    ${CREATE_APP_CTX}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   AppContext
    Set Suite Variable    ${APP_CTX_ID}    ${response['body']['contextId']
    Should Not Be Empty    ${APP_CTX_ID}
