''[Documentation]   robot --outputdir ../../outputs ./RnisQuery_BV.robot
...    Test Suite to validate RNIS/Subscription (RNIS) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    environment/pics.txt
Resource    resources/GenericKeywords.robot
Resource    resources/RadioNetworkInformationAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false



*** Test Cases ***
Request RNIS subscription list
    [Documentation]   TC_MEC_SRV_RNIS_011_OK
    ...  Check that the RNIS service sends the list of links to the relevant RNIS subscriptions when requested
    ...  ETSI GS MEC 012 2.0.4, clause 7.6.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml#/definitions/SubscriptionLinkList
    Get RNIS subscription list
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   RadioNetworkInformationAPI
    Check Subscription    ${response['body']['SubscriptionLinkList']}    ${SUBSCRIPTION_VALUE}


Create RNIS subscription
    [Documentation]   TC_MEC_SRV_RNIS_012_OK
    ...  Check that the RNIS service creates a new RNIS subscription
    ...  ETSI GS MEC 012 2.0.4, clause 7.6.3.4
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml
    Post RNIS subscription request    {"CellChangeSubscription": {"subscriptionType": CELL_CHANGE, "callbackReference": "${HREF}", "_links": {"self": "${LINKS_SELF}"}, "filterCriteria": {"appInsId": "01", "associateId": [{"type": "UE_IPV4_ADDRESS", "value": 1}], "plmn": {"mcc": "01", "mnc": "001"}, "cellId": ["800000"], "hoStatus": "COMPLETED"}, "expiryDeadline": {"seconds": 1577836800, "nanoSeconds": 0}}}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   RadioNetworkInformationAPI
    Check CellChangeSubscription    ${response['body']['CellChangeSubscription']}


*** Keywords ***
Get RNIS subscription list
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    /exampleAPI/rni/v2/subscriptions?subscription_type=${SUBSCRIPTION_HREF_VALUE}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Post RNIS subscription request
    [Arguments]    ${content}
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Post    /exampleAPI/rni/v2/subscriptions    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
