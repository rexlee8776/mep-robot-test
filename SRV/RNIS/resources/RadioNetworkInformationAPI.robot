*** Settings ***
Resource    ../environment/variables.txt
Resource    ../environment/pics.txt
Resource    GenericKeywords.robot
Library    REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false
Library    JSONSchemaLibrary    schemas/


*** Keywords ***
Check Subscription
    [Arguments]    ${received_value}    ${expected_value}
    Should Be Equal    ${received_value['_links']['self']}    ${LINKS_SELF}
    :FOR  ${item}  IN  @{received_value['subscription']}
    \  Exit For Loop If    ${item} == ${expected_value}
    Log    Item found ${item}
    [return]    ${item}


Check CellChangeSubscription
    [Arguments]    ${received_value}
    Should Be Equal    ${received_value['_links']['self']}    ${LINKS_SELF}
