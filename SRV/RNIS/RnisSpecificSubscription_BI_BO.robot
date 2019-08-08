''[Documentation]   robot --outputdir ../../outputs ./RnisSpecificSubscription_BI_BO.robot
...    Test Suite to validate RNIS/Subscription (RNIS) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../pics.txt
Resource    ../../GenericKeywords.robot
Resource    resources/RadioNetworkInformationAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false



*** Test Cases ***
Request RNIS subscription list using bad parameters
    [Documentation]   TC_MEC_SRV_RNIS_011_BR
    ...  Check that the RNIS service responds with an error when it receives a request to get all RNIS subscriptions with a wrong subscription type
    ...  ETSI GS MEC 012 2.0.4, clause 7.6.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml#/definitions/SubscriptionLinkList
    Get RNIS subscription list with wrong parameter
    Check HTTP Response Status Code Is    400
    Check ProblemDetails    400


Create RNIS subscription using bad parameters
    [Documentation]   TC_MEC_SRV_RNIS_012_BR
    ...  Check that the RNIS service responds with an error when it receives a request to create a new RNIS subscription with a wrong format
    ...  ETSI GS MEC 012 2.0.4, clause 7.6.3.4
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml
    Post RNIS subscription request    {"CellChangeSubscription": {"subscriptionType": WRONG_PARAMETER, "callbackReference": "${HREF}", "_links": {"self": "${LINKS_SELF}"}, "filterCriteria": {"appInsId": "01", "associateId": [{"type": "UE_IPV4_ADDRESS", "value": 1}], "plmn": {"mcc": "01", "mnc": "001"}, "cellId": ["800000"], "hoStatus": "COMPLETED"}, "expiryDeadline": {"seconds": 1577836800, "nanoSeconds": 0}}}
    Check HTTP Response Status Code Is    400
    Check ProblemDetails    400


*** Keywords ***
Get RNIS subscription list with wrong parameter
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Post    /exampleAPI/rni/v2/subscriptions?subscription_type=InvalidSubscriptionRef
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
