*** Settings ***
Resource    ../environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
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


Check RabInfo
    [Arguments]    ${received_value}
    log    ${received_value}
    Should Be Equal    ${received_value['appInsId']}    ${APP_INS_ID}
    Should Not Contain    ${received_value['requestId']}    ""
    Should Be Equal    ${received_value['cellUserInfo'][0]['ecgi']['cellId']}    ${CELL_ID}
    # TODO How to check the presence of a field


Check PlmnInfo
    [Arguments]    ${received_value}
    log    ${received_value}
    Should Be Equal    ${received_value['appInsId']}    ${APP_INS_ID}
    Should Not Contain    ${received_value['plmn'][0]['mcc']}    ""
    Should Not Contain    ${received_value['plmn'][0]['mnc']}    ""
    # TODO How to check the presence of a field


Check S1BearerInfo
    [Arguments]    ${received_value}
    log    ${received_value}
    #Should Not Contain    ${received_value['s1UeInfo'][0]['ecgi']['cellId']}    ${CELL_ID}
    # TODO How to check the presence of a field
