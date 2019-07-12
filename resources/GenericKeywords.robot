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


Check Location
    [Arguments]    ${value}
    Log    Check Location for userInfo element
    Should be Equal    ${response['body']['userInfo']['zoneId']}    ${value}
    Log    Location OK

Should Be Present In Json List
    [Arguments]     ${expr}   ${json_field}   ${json_value}
    Log    Check if ${json_field} is present in ${expr} with the value ${jsonvalue}
    :FOR  ${item}  IN  @{expr}
    \  Exit For Loop If    "${item['${json_field}']}" == "${json_value}"
    Log    Item found ${item}
    [return]    ${item}

Check User Identity Tag state
    [Arguments]    ${ue_identity_tag}    ${state}
    Log    Check ueIdentityTag state
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"Basic YWxhZGRpbjpvcGVuc2VzYW1l"}
    Set Headers    {"Content-Length":"0"}
    Get    /exampleAPI/ui/v1/${APP_INSTANCE_ID}/ue_identity_tag_info?ueIdentityTag=${ue_identity_tag}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ueIdentityTagInfo
    #Log    Check ueIdentityTagsList for ${UE_IDENTITY_TAG} element
    ${result}=    Should Be Present In Json List    ${response['body']['ueIdentityTagInfo']['ueIdentityTags']}    ueIdentityTag    ${UE_IDENTITY_TAG}
    #Log    ${UE_IDENTITY_TAG} found with state ${result}
    Should Be Equal    ${result}[state]    ${state}
    [return]    ${state}
