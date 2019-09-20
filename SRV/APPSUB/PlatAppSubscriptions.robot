*** Settings ***

Documentation
...    A test suite for validating Application Subscriptions (APPSUB) operations.

Resource    ../../GenericKeywords.robot

Default Tags    TP_MEC_SRV_APPSUB


*** Variables ***


*** Test Cases ***

TP_MEC_SRV_APPSUB_001_OK
    [Documentation]
    ...    Check that the IUT responds with a list of subscriptions for notifications
    ...    on services availability when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.6.3.1
    ...    OpenAPI    https://forge.etsi.org/gitlab/mec/gs011-app-enablement-api/blob/master/Mp1.yaml#/definitions/Mp1SubscriptionLinkList

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/subscriptions
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    SubscriptionLinkList


TP_MEC_SRV_APPSUB_001_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.6.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_ME_APP_SUPPORT_URI}/${NON_EXISTENT_APP_INSTANCE_ID}/subscriptions
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_APPSUB_002_OK
    [Documentation]
    ...    Check that the IUT acknowledges the subscription by a MEC Application
    ...    to notifications on service availability events
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.6.3.4"

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPOST    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/subscriptions    ${APP_TERM_NOTIF_SUB}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    AppTerminationNotificationSubscription
    Check HTTP Response Header    Location    ${LOCATION_HEADER}
    Check Result Contains    ${response['body']['AppTerminationNotificationSubscription']}    subscriptionType    "AppTerminationNotificationSubscription"
    Check Result Contains    ${response['body']['AppTerminationNotificationSubscription']}    callbackReference    ${APP_TERM_NOTIF_CALLBACK_URI}


TP_MEC_SRV_APPSUB_003_OK
    [Documentation]
    ...    Check that the IUT responds with the information on a specific subscription
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.5.3.1
    ...    OpenAPI    https://forge.etsi.org/gitlab/mec/gs011-app-enablement-api/blob/master/Mp1.yaml#/definitions/SerAvailabilityNotificationSubscription

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/subscriptions/${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    AppTerminationNotificationSubscription
    Check Result Contains    ${response['body']['AppTerminationNotificationSubscription']}    subscriptionType    "AppTerminationNotificationSubscription"


TP_MEC_SRV_APPSUB_003_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/subscriptions/${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_APPSUB_004_OK
    [Documentation]
    ...    Check that the IUT acknowledges the unsubscribe from service availability event notifications
    ...    when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.5.3.5

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vDELETE without e-tag    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/subscriptions/${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204


TP_MEC_SRV_APPSUB_004_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.8, clause 7.14.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vDELETE without e-tag    /${PX_ME_APP_SUPPORT_URI}/${NON_EXISTENT_APP_INSTANCE_ID}/subscriptions/${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404
