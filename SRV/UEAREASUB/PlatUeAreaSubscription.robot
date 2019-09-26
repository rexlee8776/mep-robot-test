*** Settings ***

Documentation
...    A test suite for validating UE Area Subscribe (UEAREASUB) operations.

Resource    ../../GenericKeywords.robot

Default Tags    TP_MEC_SRV_UEAREASUB


*** Variables ***


*** Test Cases ***

TP_MEC_SRV_UEAREASUB_001_OK
    [Documentation]
    ...    Check that the IUT acknowledges the UE area change subscription request when
    ...    commanded by a MEC Application and notifies it when the UE enters the specified circle
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.11
    ...    OpenAPI    # TODO check this

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPOST    /${PX_UE_AREA_SUB_URI}    ${MEC_APP_UEAREASUB_DATA}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    circleNotificationSubscription
    Check Result Contains    ${response['body']['circleNotificationSubscription']}    clientCorrelator    ${UEAREASUB_CLIENT_ID} 
    Check Result Contains    ${response['body']['circleNotificationSubscription']}    callbackReference    ${APP_UEAREASUB_CALLBACK_URI}
    Check Result Contains    ${response['body']['circleNotificationSubscription']}    address    ${IP_ADDRESS}
    
    # TODO how to send this when the UE enters the area? The TP has the IUT doing this immediately. Do we want this or will it be discarded as part of the test?
    # // MEC 013, clause 7.3.11.3
    # the IUT entity sends a vPOST containing
    # uri indicating value CALLBACK_URL,
    # body containing
    # subscriptionNotification containing
    # terminalLocation containing
    # address set to IP_ADDRESS
    # ;
    # ;
    # ;
    # ;


TP_MEC_SRV_UEAREASUB_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.11

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPOST    /${PX_UE_AREA_SUB_URI}    ${MEC_APP_UEAREASUB_DATA_BR}
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_UEAREASUB_002_OK
    [Documentation]
    ...    Check that the IUT acknowledges the cancellation of UE area change notifications
    ...    when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.6

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vDELETE without e-tag    /${PX_UE_AREA_SUB_URI}/${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204


TP_MEC_SRV_UEAREASUB_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request sent by a MEC Application doesn't comply with a required condition
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.6

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vDELETE without e-tag    /${PX_UE_AREA_SUB_URI}/${NON_EXISTING_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    412

