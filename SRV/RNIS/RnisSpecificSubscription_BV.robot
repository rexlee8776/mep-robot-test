''[Documentation]   robot --outputdir ../../outputs ./RnisSpecificSubscription_BV.robot
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
    log    ${response['body']['SubscriptionLinkList']['_links']}
    Should Be Equal    ${response['body']['SubscriptionLinkList']['_links']['self']}    ${LINKS_SELF}


*** Keywords ***
Get RNIS subscription list
    Should Be True    ${PIC_RNIS_SPECIFIC_SUBSCRIPTION} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    /exampleAPI/rni/v2/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
