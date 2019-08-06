*** Settings ***
Resource    ../environment/variables.txt
Resource    GenericKeywords.robot
Library    REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false
Library    JSONSchemaLibrary    schemas/

*** Keywords ***
Get User Equipment for location with filters
    [Arguments]    ${value}
    Set Headers  {"Accept":"application/json"}
    Get    /location/v2/users/${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Check HTTP Response Status Code Is
    [Arguments]    ${expected_status}
    ${status}=    Convert To Integer    ${expected_status}
    Should Be Equal    ${response['status']}    ${status}
    Log    Status code validated

Check HTTP Response Body Json Schema Is
    [Arguments]    ${input}
    Should Contain    ${response['headers']['Content-Type']}    application/json
    ${schema} =    Catenate    SEPARATOR=    ${input}    .schema.json
    Validate Json    ${schema}    ${response['body']}
    Log    Json Schema Validation OK

Should Be Present In Json List
    [Arguments]     ${expr}   ${json_field}   ${json_value}
    Log    Check if ${json_field} is present in ${expr} with the value ${jsonvalue}
    :FOR  ${item}  IN  @{expr}
    \  Exit For Loop If    "${item['${json_field}']}" == "${json_value}"
    Log    Item found ${item}
    [return]    ${item}

Check Result Contains
    [Arguments]    ${source}    ${parameter}    ${value}
    Should Be Present In Json List    ${source}    ${parameter}    ${value}
