''[Documentation]   robot --outputdir ./outputs ./SRV/UETAG/PlatUeIdentity.robot
...    Test Suite to validate UE Identity Tag (UETAG) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../pics.txt
Resource    ../../GenericKeywords.robot
Library     REST    ${AMS_SCHEMA}://${AMS_HOST}:${AMS_PORT}    ssl_verify=false
Library     BuiltIn
Library     OperatingSystem
Library     MockServerLibrary




*** Test Cases ***
Request Registered AMS information
    [Documentation]   TP_MEC_SRV_AMS_001_OK
    ...  Check that the AMS service returns information about the registered application mobility services when requested
    ...  ETSI GS MEC 021 2.0.8, clause 8.3.3.1
    Get Registered AMS information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   AppMobilityServiceInfos


Request Registered AMS information using attribute-selector    
    [Documentation]   TP_MEC_SRV_AMS_001_OK
    ...  Check that the AMS service returns information about the registered application mobility services when requested
    ...  ETSI GS MEC 021 2.0.8, clause 8.3.3.1
    Get Registered AMS information using attribute-selector    appMobilityServiceId    ${APP_MOBILITY_SERVICE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   AppMobilityServiceInfos
    Check Result Contains    ${response['body']['AppMobilityServiceInfo']}    appMobilityServiceId    ${APP_MOBILITY_SERVICE_ID}
    

Request Registered AMS information using bad parameters
    [Documentation]   TP_MEC_SRV_AMS_001_BR
    ...  Check that the AMS service returns an error when receives a query about a registered application mobility service with wrong parameters
    ...  ETSI GS MEC 021 2.0.8, clause 8.3.3.1
    Get Registered AMS information using bad parameters
    Check HTTP Response Status Code Is    400


Register a new application mobility services
    [Documentation]   TP_MEC_SRV_AMS_002_OK
    ...  Check that the AMS service creates a new application mobility services when requested
    ...  ETSI GS MEC 021 2.0.8, clause 8.3.3.4
    Create a new application mobility service      RegistrationRequest
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    AppMobilityServiceInfo
    Log    Checking Postcondition
    Check Result Contains    ${response['body']['AppMobilityServiceInfo']['registeredAppMobilityService']['serviceConsumerId']['']}    appInstanceId    ${APP_INS_ID}
    

Register an UE Identity Tag using invalid parameter
    [Documentation]   TP_MEC_SRV_AMS_002_BR
    ...  Check that the AMS service sends an error when it receives a malformed request to create a new application mobility service
    ...  ETSI GS MEC 021 2.0.8, clause 8.3.3.4
    Create a new application mobility service    RegistrationRequestMalformed
    Check HTTP Response Status Code Is    400


Request Subscriptions List for the registered AMS services
    [Documentation]   TP_MEC_SRV_AMS_003_OK
    ...  Check that the AMS service returns information about the available subscriptions when requested.
    ...     Permitted SUBSCRIPTION_TYPE are:
    ...     - MobilityProcedureSubscription
    ...     - AdjacentAppInfoSubscription"
    ...  ETSI GS MEC 021 2.0.8, clause 8.6.3.1
    Get Subscriptions for registered AMS
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    SubscriptionLinks



Request Subscription List for registered AMS Services using wrong attribute parameters
    [Documentation]   TP_MEC_SRV_AMS_003_BR
    ...  Check that the AMS service sends an error when it receives a malformed query about the available subscriptions
    Get Subscriptions for registered AMS with wrong attbirube parameter
    Check HTTP Response Status Code Is    400



Create a notification subscription
    [Documentation]   TP_MEC_SRV_AMS_004_OK
    ...  Check that the AMS service creates a notification subscriptions when requested.
    ...     Permitted SUBSCRIPTION_TYPE are:
    ...     - MobilityProcedureSubscription
    ...     - AdjacentAppInfoSubscription"
    ...  ETSI GS MEC 021 2.0.8, clause 8.6.3.4
    Post a new notification subscription    NotificationSubscription
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    NotificationSubscription
    

Create a notification subscription with wrong attribute parameter
    [Documentation]   TP_MEC_SRV_AMS_004_BR
    ...  Check that the AMS service creates a notification subscriptions when requested.
    ...     Permitted SUBSCRIPTION_TYPE are:
    ...     - MobilityProcedureSubscription
    ...     - AdjacentAppInfoSubscription"
    ...  ETSI GS MEC 021 2.0.8, clause 8.6.3.4
    Post a new notification subscription    NotificationSubscriptionError
    Check HTTP Response Status Code Is    400



Request a specific subscription
    [Documentation]   TP_MEC_SRV_AMS_005_OK
    ...  Check that the AMS service returns information about a given subscription when requested.
    ...     Permitted SUBSCRIPTION_TYPE are:
    ...     - MobilityProcedureSubscription
    ...     - AdjacentAppInfoSubscription"
    ...  ETSI GS MEC 021 2.0.8, clause 8.7.3.1
    Get individual subscription for AMS services    ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NotificationSubscription




Request a specific subscription using wrong identifier
    [Documentation]   TP_MEC_SRV_AMS_005_NF
    ...  Check that the AMS service returns an error when receives a query about a not existing subscription
    ...     ETSI GS MEC 021 2.0.8, clause 8.7.3.1
    Get individual subscription for AMS services    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404



Modify a specific subscription
    [Documentation]   TP_MEC_SRV_AMS_007_OK
    ...  Check that the AMS service modifies a given subscription when requested.
    ...  Permitted SUBSCRIPTION_TYPE are:
    ...    - MobilityProcedureSubscription
    ...    - AdjacentAppInfoSubscription
    ...  ETSI GS MEC 021 2.0.8, clause 8.7.3.2
    Update individual subscription for AMS services    ${SUBSCRIPTION_ID}    NotificationSubscription
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    NotificationSubscription



Modify a specific subscription using malformed request
    [Documentation]   TP_MEC_SRV_AMS_007_BR
    ...  Check that the AMS service sends an error when it receives a malformed modify request for a given subscription.
    ...  Permitted SUBSCRIPTION_TYPE are:
    ...    - MobilityProcedureSubscription
    ...    - AdjacentAppInfoSubscription
    ...  ETSI GS MEC 021 2.0.8, clause 8.7.3.2
    Update individual subscription for AMS services    ${SUBSCRIPTION_ID}    NotificationSubscriptionError
    Check HTTP Response Status Code Is    400


Modify a specific subscription using wrong identifier
    [Documentation]   TP_MEC_SRV_AMS_007_NF
    ...  Check that the AMS service sends an error when it receives a modify request for a not existing subscription.
    ...  ETSI GS MEC 021 2.0.8, clause 8.7.3.2
    Update individual subscription for AMS services    ${NON_EXISTENT_SUBSCRIPTION_ID}    NotificationSubscription
    Check HTTP Response Status Code Is    404


Remove a specific subscription
    [Documentation]   TP_MEC_SRV_AMS_006_OK
    ...  Check that the AMS service deletes a given subscription when requested
    ...  ETSI GS MEC 021 2.0.8, clause 8.7.3.5
    Delete individual subscription for AMS services    ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204


Remove a specific subscription using wrong identifier
    [Documentation]   TP_MEC_SRV_AMS_006_NF
    ...  Check that the AMS service sends an error when it receives a delete request for a not existing subscription
    ...  ETSI GS MEC 021 2.0.8, clause 8.7.3.5
    Delete individual subscription for AMS services    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404



Post Mobility Procedure Notification
    [Documentation]   TP_MEC_SRV_AMS_008_OK
    ...  Check that the AMS service sends an AMS notification  about a mobility procedure 
    ...    if the AMS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 021 2.0.8, clause 7.4.2
    ${json}=	Get File	schemas/MobilityProcedureNotification.schema.json
    Log  Creating mock request and response to handle  Mobility Procedure Notification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint} 
    


Post Adjacent Application Info Notification
    [Documentation]   TP_MEC_SRV_AMS_009_OK
    ...  Check that the AMS service sends an AMS notification about adjacent application instances 
    ...    if the AMS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 021 2.0.8, clause 7.4.3
    ${json}=	Get File	schemas/AdjacentAppInfoNotification.schema.json
    Log  Creating mock request and response to handle Adjacent Application Info Notification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint} 



Post Expire Notification
    [Documentation]   TP_MEC_SRV_AMS_010_OK
    ...  Check that the AMS service sends an AMS notification on subscription expiration
    ...    if the AMS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 021 2.0.8, clause 7.4.4
    ${json}=	Get File	schemas/ExpireNotification.schema.json
    Log  Creating mock request and response to handle Expire Notification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint} 

        

*** Keywords ***
Get Registered AMS information
    Should Be True    ${PIC_AMS} == '1'
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/appMobilityServices
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Get Registered AMS information using attribute-selector
    [Arguments]    ${key}    ${value}
    Should Be True    ${PIC_AMS} == '1'
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/appMobilityServices?${key}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    
Get Registered AMS information using bad parameters
    Should Be True    ${PIC_AMS} == '1'
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/appMobilityServices?appMobilityService=${APP_MOBILITY_SERVICE_ID}     //param should be appMobilityServiceId
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Create a new application mobility service
    [Arguments]    ${content}
    Should Be True    ${PIC_AMS} == '1'
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    json/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/appMobilityServices    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Get Subscriptions for registered AMS    
    Should Be True    ${PIC_AMS} == '1'
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    
    
Get Subscriptions for registered AMS with wrong attbirube parameter
    Should Be True    ${PIC_AMS} == '1'
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions?subscriptionTyp=${SUBSCRIPTION_TYPE}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}



Post a new notification subscription
    [Arguments]    ${content}
    Should Be True    ${PIC_AMS} == '1'
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    json/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    
    
Get individual subscription for AMS services
    [Arguments]    ${content}
    Should Be True    ${PIC_AMS} == '1'
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   
    

Delete individual subscription for AMS services 
    [Arguments]    ${content}
    Should Be True    ${PIC_AMS} == '1'
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}      


Update individual subscription for AMS services
    [Arguments]    ${identifier}    ${content}
    Should Be True    ${PIC_AMS} == '1'
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    json/    ${content}    .json
    ${body}=    Get File    ${file}
    Put    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${identifier}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    