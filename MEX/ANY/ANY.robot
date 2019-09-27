*** Settings ***
Resource    environment/variables.txt
Resource    ../../GenericKeywords.robot
Library     REST    ${PROVIDER_SCHEMA}://${PROVIDER_HOST}:${PROVIDER_PORT}    ssl_verify=false
Library     BuiltIn
Library     OperatingSystem
Library     Collections
Library     String


*** Variable ***
@{data}    https|localhost|8080|/alcmi/v1/app_instances|POST|{"key":"value"}    https|localhost|8080|/alcmi/v1/app_instances|GET    https|localhost|8080|/alcmi/v1/app_instances|PUT    
${token}    Bearer InvalidToken
*** Test Cases ***
Request access to all resources using no token
    [Documentation]    TP_MEC_MEX_ANY_001_NT
    ...    Check that a MEC API provider responds with an error when it 
    ...    receives a request without token
    ...    ETSI GS MEC 009 1.1.1, clause 6.16.1
    [Tags]    GENERIC_TESTS    INCLUDE_UNDEFINED_SCHEMAS
    : FOR    ${INDEX}    IN RANGE    0    3
    \    @{list}    Split String    ${data[${INDEX}]}    separator=|    max_split=-1
    \    Perform a generic request using no token    @{list[${INDEX}]}
    \    Perform a generic request using invalid token    @{data[${INDEX}]}
    


*** Keywords ***
Perform a generic request using no token
    [Arguments]   @{params}
    Run Keyword If     '@{params[4]}' == "POST"
    ...    Perform a POST using no token        ${params[0]}    ${params[1]}    ${params[2]}    ${params[3]}   ${params[5]}
    Run Keyword If     '@{params[4]}' == "GET"
    ...    Perform a GET using no token        ${params[0]}    ${params[1]}    ${params[2]}    ${params[3]}
    Run Keyword If     '@{params[4]}' == "DELETE"
    ...    Perform a DELETE using no token        ${params[0]}    ${params[1]}    ${params[2]}    ${params[3]}
    Run Keyword If     '@{params[4]}' == "PUT"
    ...    Perform a PUT using no token        ${params[0]}    ${params[1]}    ${params[2]}    ${params[3]}   ${params[5]}
    Run Keyword If     '@{params[4]}' == "PATCH"
    ...    Perform a PATCH using no token        ${params[0]}    ${params[1]}    ${params[2]}    ${params[3]}   ${params[5]}


Perform a generic request using invalid token
    [Arguments]    @{params}
    Run Keyword If     '@{params[4]}' == "POST"
    ...    Perform a POST using invalid token        ${token}    ${params[0]}    ${params[1]}    ${params[2]}    ${params[3]}   ${params[5]}
    Run Keyword If     '@{params[4]}' == "GET"
    ...    Perform a GET using invalid token        ${token}    ${params[0]}    ${params[1]}    ${params[2]}    ${params[3]}
    Run Keyword If     '@{params[4]}' == "DELETE"
    ...    Perform a DELETE using invalid token        ${token}    ${params[0]}    ${params[1]}    ${params[2]}    ${params[3]}
    Run Keyword If     '@{params[4]}' == "PUT"
    ...    Perform a PUT using invalid token        ${token}    ${params[0]}    ${params[1]}    ${params[2]}    ${params[3]}   ${params[5]}
    Run Keyword If     '@{params[4]}' == "PATCH"
    ...    Perform a PATCH using invalid token        ${token}    ${params[0]}    ${params[1]}    ${params[2]}    ${params[3]}   ${params[5]}


Perform a POST using no token
    [Arguments]    ${schema}    ${ip}    ${port}    ${uri}    ${payload}
    Log    "Running post"
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    POST    ${schema}://${ip}:${port}/${uri}    ${payload}
    Log    ${schema}://${ip}:${port}/${uri}    ${payload}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}



Perform a GET using no token
    [Arguments]    ${schema}    ${ip}    ${port}    ${uri}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Log    ${schema}://${ip}:${port}/${uri}    
    GET    ${schema}://${ip}:${port}/${uri}    
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}



Perform a DELETE using no token
    [Arguments]    ${schema}    ${ip}    ${port}    ${uri}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Log    ${schema}://${ip}:${port}/${uri}    
    DELETE    ${schema}://${ip}:${port}/${uri}    
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}


Perform a PUT using no token
    [Arguments]    ${schema}    ${ip}    ${port}    ${uri}    ${payload}=None
    Log    "Running post"
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Log    ${schema}://${ip}:${port}/${uri}    ${payload}
    PUT    ${schema}://${ip}:${port}/${uri}    ${payload}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}


Perform a PATCH using no token
    [Arguments]    ${schema}    ${ip}    ${port}    ${uri}    ${payload}=None
    Log    "Running post"
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Log    ${schema}://${ip}:${port}/${uri}    ${payload}
    PATCH    ${schema}://${ip}:${port}/${uri}    ${payload}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}

    
Perform a POST using invalid token
    [Arguments]   ${token}    ${schema}    ${ip}    ${port}    ${uri}    ${payload}=None
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${token}"}    
    Set Headers    {"Content-Type":"application/json"}
    Log    ${schema}://${ip}:${port}/${uri}    ${payload}
    POST    ${schema}://${ip}:${port}/${uri}    ${payload}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}




Perform a GET using invalid token
    [Arguments]   ${token}    ${schema}    ${ip}    ${port}    ${uri}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${token}"}    
    Set Headers    {"Content-Type":"application/json"}
    Log    ${schema}://${ip}:${port}/${uri}
    GET    ${schema}://${ip}:${port}/${uri}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}


Perform a DELETE using invalid token
    [Arguments]   ${token}    ${schema}    ${ip}    ${port}    ${uri}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${token}"}    
    Set Headers    {"Content-Type":"application/json"}
    Log    ${schema}://${ip}:${port}/${uri}
    DELETE    ${schema}://${ip}:${port}/${uri}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}


Perform a PUT using invalid token
    [Arguments]   ${token}    ${schema}    ${ip}    ${port}    ${uri}    ${payload}=None
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${token}"}    
    Set Headers    {"Content-Type":"application/json"}
    Log    ${schema}://${ip}:${port}/${uri}    ${payload}
    PUT    ${schema}://${ip}:${port}/${uri}    ${payload}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}


Perform a PATCH using invalid token
    [Arguments]   ${token}    ${schema}    ${ip}    ${port}    ${uri}    ${payload}=None
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${token}"}    
    Set Headers    {"Content-Type":"application/json"}
    Log    ${schema}://${ip}:${port}/${uri}    ${payload}
    PATCH    ${schema}://${ip}:${port}/${uri}    ${payload}
    ${output}=    Output    response
    Should Be Equal As Strings    401    ${output['status']}
