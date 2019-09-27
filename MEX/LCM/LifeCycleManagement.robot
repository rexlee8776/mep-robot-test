*** Settings ***
Resource    environment/variables.txt
Resource    ../../GenericKeywords.robot
Library     REST    ${MEX_SCHEMA}://${MEX_HOST}:${MEX_PORT}    ssl_verify=false
Library     BuiltIn
Library     OperatingSystem
Library     MockServerLibrary


*** Test Cases ***
Create new App Package Resource
    [Documentation]   TP_MEC_MEX_LCM_001_OK
    ...  Check that MEC API provider creates a new App Instance when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.1.3.1
    ...    ETSI GS MEC 010-2 2.0.10, Table 6.2.2.3.2-1 (CreateAppInstanceRequest)
    ...    ETSI GS MEC 010-2 2.0.10, Table 6.2.2.4.2-1 (AppInstanceInfo)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Post Request to create new App instance        CreateAppInstanceRequest
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   AppInstanceInfo
    Check HTTP Response Header Contains    Location
    Check Result Contains    ${response}    appDId    ${APPD_ID}
    Check Result Contains    ${response}    instantiationState    ${INSTANTIATION_STATE}


Create new App Instance using malformed request
    [Documentation]   TP_MEC_MEX_LCM_001_BR
    ...  Check that MEC API provider sends an error when it receives a malformed request 
    ...  for the creation of a new App Instance
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.1.3.1
    ...    ETSI GS MEC 010-2 2.0.10, Table 6.2.2.3.2-1 (CreateAppInstanceRequest)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Post Request to create new App instance        MalformedAppInstanceRequest
    Check HTTP Response Status Code Is    400


Request all APP Instances
    [Documentation]    TP_MEC_MEX_LCM_002_OK
    ...    Check that MEC API provider retrieves the list of App instances when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.1.3.2
    ...    ETSI GS MEC 010-2 2.0.10, Table 6.2.2.4.2-1 (AppInstanceInfo)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    GET all APP instances
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   AppInstanceInfos
    Check Result Contains    ${response}    appInstanceId    ${APP_INSTANCE_ID}

        
    
Request an individual APP instance
    [Documentation]    TP_MEC_MEX_LCM_003_OK
    ...    Check that MEC API provider retrieves an App Instance when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.2.3.2
    ...    ETSI GS MEC 010-2 2.0.10, Table 6.2.2.4.2-1 (AppInstanceInfo)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    GET an APP instance identified by    ${APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   OnboardedAppPkgInfo
    Check Result Contains    ${response}    appInstanceId    ${APP_INSTANCE_ID}
    
    
Request an individual APP instance using wrong identifier
    [Documentation]    TP_MEC_MEX_LCM_003_NF
    ...    Check that MEC API provider fails on retrieving an App Instance when requested using wrong appInstanceId
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.2.3.2
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    GET an APP instance identified by    ${NON_EXISTENT_APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    404
    


Remove an individual APP instance
    [Documentation]    TP_MEC_MEX_LCM_004_OK
    ...    Check that MEC API provider service deletes an App Instance when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.2.3.4
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Delete an individual APP instance identified by    ${APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    204
    Check HTTP Response Body is Empty
    

Remove an individual APP Package using wrong identifier
    [Documentation]    TP_MEC_MEX_LCM_004_NF
    ...    Check that MEC API provider fails on deletion of an App Instance when requested using wrong appInstanceId
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.2.3.2
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Delete an individual APP instance identified by    ${NON_EXISTENT_APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    404


Instantiate an APP instance 
    [Documentation]    TP_MEC_MEX_LCM_005_OK
    ...    Check that MEC API provider service instantiates an App Instance when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.6.3.1
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.7.2-1 (InstantiateAppRequest)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for APP instantiation    ${APP_INSTANCE_ID}    InstantiateAppRequest
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body is Empty
    
    
Instantiate an APP instance using malformed parameters
    [Documentation]    TP_MEC_MEX_LCM_005_BR
    ...    Check that MEC API provider service fails to instantiate an App Instance when it receives a malformed request
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.6.3.1
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.7.2-1 (InstantiateAppRequest)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for APP instantiation    ${APP_INSTANCE_ID}    MalformedInstantiateAppRequest
    Check HTTP Response Status Code Is    400



Instantiate a not existant APP instance
    [Documentation]    TP_MEC_MEX_LCM_005_NF
    ...    Check that MEC API provider service fails to instantiate an App Instance when it receives a
    ...    request related to a not existing App Instance
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.6.3.1
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.7.2-1 (InstantiateAppRequest)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for APP instantiation    ${NON_EXISTENT_APP_INSTANCE_ID}    InstantiateAppRequest
    Check HTTP Response Status Code Is    404


Terminate an APP instance 
    [Documentation]    TP_MEC_MEX_LCM_006_OK
    ...    Check that MEC API provider service terminates an App Instance when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.7.3.1
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.9.2-1 (TerminateAppRequest)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for APP termination    ${APP_INSTANCE_ID}    TerminateAppRequest
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body is Empty



Terminate an APP instance using malformed parameters
    [Documentation]    TP_MEC_MEX_LCM_006_BR
    ...    Check that MEC API provider service fails to terminate an App Instance 
    ...    when it receives a malformed request
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.7.3.1
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.9.2-1 (TerminateAppRequest)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for APP termination    ${APP_INSTANCE_ID}    MalformedTerminateAppRequest
    Check HTTP Response Status Code Is    400



Terminate a not existant APP instance
    [Documentation]    TP_MEC_MEX_LCM_006_NF
    ...    heck that MEC API provider service fails to terminate an App Instance when it receives a
    ...    request related to a not existing App Instance
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.7.3.1
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.9.2-1 (TerminateAppRequest)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for APP instantiation    ${NON_EXISTENT_APP_INSTANCE_ID}    TerminateAppRequest
    Check HTTP Response Status Code Is    404
    
    
    
Change status of an APP instance 
    [Documentation]    TP_MEC_MEX_LCM_007_OK
    ...    Check that MEC API provider service changes the status of an App Instance from its INITIAL_STATE to a given FINAL_STATE, when requested.
    ...    The following combinations INITIAL_STATE - FINAL_STATE are supported: 
    ...     - STARTED/STOP
    ...     - STOPPED/START
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.8.3.1
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.8.2-1 (OperateAppRequest)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for APP operation    ${APP_INSTANCE_ID}    OperateAppRequest
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body is Empty



Change status of an APP instance using malformed parameters
    [Documentation]    TP_MEC_MEX_LCM_007_BR
    ...    Check that MEC API provider service fails to operate on an App Instance when it receives a malformed request
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.8.3.1
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.8.2-1 (OperateAppRequest)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for APP termination    ${APP_INSTANCE_ID}    MalformedOperateAppRequest
    Check HTTP Response Status Code Is    400



Change status on a not existant APP instance
    [Documentation]    TP_MEC_MEX_LCM_007_NF
    ...    Check that MEC API provider service fails to change the status of an App Instance 
    ...    when it receives a request related to a not existing App Instance
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.8.3.1
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.8.2-1 (OperateAppRequest)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for APP instantiation    ${NON_EXISTENT_APP_INSTANCE_ID}    OperateAppRequest
    Check HTTP Response Status Code Is    404
    
    
    
Request list of LCM Operation Occurrencies
    [Documentation]    TP_MEC_MEX_LCM_008_OK
    ...    Check that MEC API provider service retrieves info about LCM Operation Occurrency on App Instances when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.9.1.3.2
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.14.2-1 (AppInstanceLcmOpOcc)
    ...    
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for APP instance LCM Operation Occurrencies
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppInstanceLcmOpOccs
    Check Result Contains    ${response}    appLcmOpOccId    ${APP_LCM_OP_OCC_ID}        
    
    
Request a specific LCM Operation Occurrency 
    [Documentation]    TP_MEC_MEX_LCM_009_OK
    ...    Check that MEC API provider service retrieves info about LCM Operation Occurrency on an App Instance when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.10.1.3.2
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.14.2-1 (AppInstanceLcmOpOcc)
    ...    
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for a specific LCM Operation Occurrency    ${APP_LCM_OP_OCC_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppInstanceLcmOpOcc
    Check Result Contains    ${response}    appLcmOpOccId    ${APP_LCM_OP_OCC_ID}


Request a specific LCM Operation Occurrency using a non existant identifier
    [Documentation]    TP_MEC_MEX_LCM_009_NF
    ...    Check that MEC API provider service sends an error when it receives a query 
    ...    for a not existing LCM Operation Occurrency
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.10.1.3.2
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for a specific LCM Operation Occurrency    ${NON_EXISTANT_APP_LCM_OP_OCC_ID}
    Check HTTP Response Status Code Is    404


Create a new LifeCycleManagement Subscription
    [Documentation]    TP_MEC_MEX_LCM_010_OK
    ...    Check that MEC API provider service creates a LCM Subscription when requested, 
    ...    where the subscription request can have SUBSCRIPTION_TYPE:
    ...        - AppInstanceStateChangeSubscription
    ...        - AppLcmOpOccStateChangeSubscription
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.3.3.1
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.13.2-1 (AppInstSubscriptionRequest)
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.10.2-1 (AppInstSubscriptionInfo)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for a subscription    AppInstSubscriptionRequest
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    AppPkgSubscriptionInfo
    Check Result Contains    ${response}    subscriptionType   AppInstanceStateChangeSubscription
    Check Result Contains    ${response}    callbackUri    ${CALLBACK_URI}


Create a new LifeCycleManagement Subscription with malformed parameter
    [Documentation]    TP_MEC_MEO_PKGM_007_BR
    ...    Check that MEC API provider service sends an error when it receives a malformed request to create a LCM Subscription
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.3.3.1
    ...    EETSI GS MEC 010-2 2.0.10, table 6.2.2.13.2-1 (AppInstSubscriptionRequest)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Send a request for a subscription    MalformedAppInstSubscriptionRequest
    Check HTTP Response Status Code Is    400



Request all LifeCycleManagement Subscriptions
   [Documentation]    TP_MEC_MEX_LCM_011_OK
    ...    Check that MEC API provider service sends the list of LCM Subscriptions when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.3.3.2
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.13.2-1 (AppInstSubscriptionRequest)
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.15.2-1 (AppLcmOpOccSubscriptionRequest)
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.10.2-1 (AppInstSubscriptionInfo)
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.16.2-1 (AppLcmOpOccSubscriptionInfo)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    ##TODO: How to handle cases when different types of schemas can be returned?
    Get all LifeCycleManagement subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppInstSubscriptionLinkList
    Check Result Contains    ${response}    subscriptionId    ${SUBSCRIPTION_ID}

    
Request a specific LifeCycleManagement subscription
    [Documentation]    TP_MEC_MEX_LCM_012_OK
    ...    Check that MEC API provider service sends the information about an existing LCM subscription when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.4.3.2
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.10.2-1 (AppInstSubscriptionInfo)
    ...    ETSI GS MEC 010-2 2.0.10, table 6.2.2.16.2-1 (AppLcmOpOccSubscriptionInfo)
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get an individual LCM subscription   ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppInstSubscriptionInfo
    Check Result Contains    ${response}    subscriptionId    ${SUBSCRIPTION_ID}




Request a specific LifeCycleManagement subscription using non existant subscription identifier
    [Documentation]    TP_MEC_MEX_LCM_012_NF
    ...    Check that MEC API provider service sends an error when it receives a query for a not existing LCM Subscription
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.3.3.2
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get an individual LCM subscription    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404



Remove a LifeCycleManagement subscription
    [Documentation]    TP_MEC_MEX_LCM_013_OK
    ...    Check that MEC API provider service delete an existing LCM Subscription when requested
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.3.4.3.4
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Delete an LCM Subscription identified by   ${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204
    Check HTTP Response Body is Empty


Remove a APP Package subscription using non existant subscription id
    [Documentation]    TP_MEC_MEX_LCM_013_NF
    ...    Check that MEC API provider service sends an error when it receives a deletion request
    ...    for a not existing LCM Subscription
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.5.3.3.4
    [Tags]    PIC_APP_LCM_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Delete an LCM Subscription identified by    ${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404

Post Application Package Notification
    [Documentation]   TP_MEC_MEX_LCM_014_OK
    ...  Check that MEC API provider sends a notification to the subscriber when an application lcm change event occurs
    ...  ETSI GS MEC 010-2 2.0.10, clause 7.5.5.3.1
    ...  ETSI GS MEC 010-2 2.0.10, table 6.2.2.18.2-1, // AppLcmOpOccNotification
    ...  ETSI GS MEC 010-2 2.0.10, table 6.2.2.12.2-1  // AppInstNotification 
    ${json}=	Get File	schemas/LCMNotification.schema.json
    Log  Creating mock request and response to handle  LCM Notification
    &{req}=  Create Mock Request Matcher	POST  ${callback_endpoint}  body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=  Create Mock Response	headers="Content-Type: application/json"  status_code=204
    Create Mock Expectation  ${req}  ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}   ${polling_interval}   Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation  ${req}
    Log  Cleaning the endpoint
    Clear Requests  ${callback_endpoint} 
         

*** Keywords ***
Post Request to create new App instance
    [Arguments]    ${content}
    Log    Creating a new App Instance
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_instances    ${content}    allow_redirects=false
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}     
   
    
GET all APP instances
    Log    Getting all App Instances
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_instances    
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
     

GET an APP instance identified by
    [Arguments]    ${value}    
    Log    Getting an App Package
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
    
Delete an individual APP instance identified by
    [Arguments]    ${value}    
    Log    Removing an App Package
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
Send a request for APP instantiation
    [Arguments]    ${appInstanceId}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${appInstanceId}/instantiate    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}     


Send a request for APP termination
    [Arguments]    ${appInstanceId}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${appInstanceId}/terminate    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   


Send a request for APP operation
    [Arguments]    ${appInstanceId}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/app_instances/${appInstanceId}/operate    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    
 
Send a request for APP instance LCM Operation Occurrencies    
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/app_lcm_op_occs
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    
Send a request for a specific LCM Operation Occurrency
    [Arguments]    ${appLcmOpOccId}   
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/app_lcm_op_occs/${appLcmOpOccId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Send a request for a subscription    
    [Arguments]    ${content}
    Log    Creating a new subscription
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
        
        
Get all LifeCycleManagement subscriptions
    Log    Getting list of subscriptions
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
    
Get an individual LCM subscription
    [Arguments]    ${subId}
    Log    Getting an individual subscription
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
Delete an LCM Subscription identified by
    [Arguments]    ${subId}
    Log    Deleting a subscription
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 