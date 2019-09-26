*** Settings ***

Documentation
...    A test suite for validating UE Distance Subscribe (UEDISTSUB) operations.

Resource    ../../GenericKeywords.robot

Default Tags    TP_MEC_SRV_UEDISTSUB


*** Variables ***


*** Test Cases ***

TP_MEC_SRV_UEDISTSUB_001_OK
    [Documentation]
    ...    Check that the IUT acknowledges the UE distance subscription request when commanded by a
    ...    MEC Application and notifies it when (all) the requested UE(s) is (are) within the specified distance
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.10
    ...    OpenAPI    # TODO check this

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPOST    /${PX_UE_DIST_SUB_URI}    ${UE_DIST_NOTIF_SUB_DATA}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    distanceNotificationSubscription
    Check Result Contains    ${response['body']['distanceNotificationSubscription']}    clientCorrelator    ${UEDISTSUB_CLIENT_ID}
    Check Result Contains    ${response['body']['distanceNotificationSubscription']}    callbackReference    ${APP_SRVSUB_NOTIF_CALLBACK_URI}
    Check Result Contains    ${response['body']['distanceNotificationSubscription']}    monitoredAddress    ${UEDISTSUB_MONITORED_IP_ADDRESS}
    Check Result Contains    ${response['body']['distanceNotificationSubscription']}    referenceAddress    ${UEDISTSUB_IP_ADDRESS}


TP_MEC_SRV_UEDISTSUB_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.10

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPOST    /${PX_UE_DIST_SUB_URI}    ${UE_DIST_NOTIF_SUB_DATA_BR}
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_UEDISTSUB_002_OK
    [Documentation]
    ...    Check that the IUT acknowledges the cancellation of UE distance notifications
    ...    when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.6

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vDELETE without e-tag    /${PX_UE_DIST_SUB_URI}/${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204


TP_MEC_SRV_UEDISTSUB_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.6

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vDELETE without e-tag    /${PX_UE_DIST_SUB_URI}/${NON_EXISTING_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404


