*** Settings ***

Documentation
...    A test suite for validating Fixed Access Information Service (FAIS) operations.

Resource    ../../GenericKeywords.robot

Default Tags    TP_MEC_SRV_FAIS


*** Variables ***


*** Test Cases ***

TP_MEC_SRV_FAIS_001_OK
    [Documentation]
    ...    Check that the IUT responds with the current status of the fixed access information
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.3.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_FA_INFO_URI}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    FaInfo


TP_MEC_SRV_FAIS_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.3.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_FA_INFO_URI}?interface=1
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_FAIS_001_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for non-existing data is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.3.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_FA_INFO_URI}?interface=999
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_FAIS_002_OK
    [Documentation]
    ...    Check that the IUT responds with the current status of the device information
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.4.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_DEVICE_INFO_URI}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    DeviceInfo


TP_MEC_SRV_FAIS_002_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.4.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_FA_INFO_URI}?device=__any_value__
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_FAIS_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for non-existing data is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.4.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_DEVICE_INFO_URI}?gwId=${NON_EXISTING_FAI_GW_ID}
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_FAIS_003_OK
    [Documentation]
    ...    Check that the IUT responds with the current status of the cable line information
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_CABLE_LINE_INFO_URI}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    CableLineInfo


TP_MEC_SRV_FAIS_003_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_CABLE_LINE_INFO_URI}?cm=__any_value__
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_FAIS_003_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for non-existing data is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.5.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_CABLE_LINE_INFO_URI}?cmId=${NON_EXISTING_FAI_CM_ID}
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_FAIS_004_OK
    [Documentation]
    ...    Check that the IUT responds with the current status of the optical network information
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.6.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_OPTICAL_NW_INFO_URI}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    PonInfo


TP_MEC_SRV_FAIS_004_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.6.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_CABLELINE_INFO_URI}?onu=__any_value__
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_FAIS_004_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for non-existing data is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.6.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_CABLELINE_INFO_URI}?cmId=${NON_EXISTING_FAI_ONU_ID}
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_FAIS_005_OK
    [Documentation]
    ...    Check that the IUT responds with the subscriptions for fixed access information notifications
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.7.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_SUB_URI}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    SubscriptionLinkList


TP_MEC_SRV_FAIS_005_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.7.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_SUB_URI}?subscription=__any_value__
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_FAIS_005_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for non-existing data is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.7.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_SUB_URI}?subscription_type=${NON_EXISTING_FAI_SUB_ID}
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_FAIS_006_OK
    [Documentation]
    ...    Check that the IUT acknowledges the subscription by a MEC Application
    ...    to notifications on Optical Network Unit alarm events
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.7.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPOST    /${PX_FAI_SUB_URI}    ${FAI_ONU_ALARM_SUB_DATA}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    OnuAlarmSubscription
    Check Result Contains    ${response['body']['OnuAlarmSubscription']}    subscriptionType    "OnuAlarmSubscription"

    # TODO how to send this? The TP has the IUT doing this immediately. Do we want this or will it be discarded as part of the test?
    # // MEC 029, clause 7.7.3.4
    # the IUT entity sends a vPOST containing
    # uri indicating value CALLBACK_URL
    # body containing
    # OnuAlarmNotification containing
    # notificationType set to "OnuAlarmSubscription"
    # ;
    # ;
    # ;
    # to the MEC_APP entity


TP_MEC_SRV_FAIS_006_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.7.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPOST    /${PX_FAI_SUB_URI}    ${FAI_ONU_ALARM_SUB_DATA_BR}
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_FAIS_007_OK
    [Documentation]
    ...    Check that the IUT responds with the information on a given subscription
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.8.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_SUB_URI}/${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    OnuAlarmSubscription
    Check Result Contains    ${response['body']['OnuAlarmSubscription']}    subscriptionType    "OnuAlarmSubscription"


TP_MEC_SRV_FAIS_007_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.8.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_FAI_SUB_URI}/${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_FAIS_008_OK
    [Documentation]
    ...    Check that the IUT updates an existing subscription
    ...    when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.8.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT    /${PX_FAI_SUB_URI}/${SUBSCRIPTION_ID}    ${FAI_ONU_ALARM_SUB_UPDT_DATA}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    OnuAlarmSubscription
    Check Result Contains    ${response['body']['OnuAlarmSubscription']}    subscriptionType    "OnuAlarmSubscription"


TP_MEC_SRV_FAIS_008_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.8.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT    /${PX_FAI_SUB_URI}    ${FAI_ONU_ALARM_SUB_UPDT_DATA_BR}
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_FAIS_008_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.8.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT    /${PX_FAI_SUB_URI}/${NON_EXISTENT_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_FAIS_008_PF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request sent by a MEC Application doesn't comply with a required condition
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.8.3.2

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT invalid e-tag    /${PX_FAI_SUB_URI}    ${FAI_ONU_ALARM_SUB_UPDT_DATA}
    Check HTTP Response Status Code Is    412


TP_MEC_SRV_FAIS_009_OK
    [Documentation]
    ...    Check that the IUT cancels an existing subscription
    ...    when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.8.3.5

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vDELETE without e-tag    /${PX_FAI_SUB_URI}/${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204


TP_MEC_SRV_UEDISTSUB_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.8.3.5

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vDELETE without e-tag    /${PX_FAI_SUB_URI}/${NON_EXISTING_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_FAIS_010_OK
    [Documentation]
    ...    Check that the IUT sends notification on expiry of Fixed Access Information event subscription
    ...    to a MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 7.7.3.4

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    # TODO how to set this? expiryDeadline indicating value NOW_PLUS_X_SECONDS    
    vPOST    /${PX_FAI_SUB_URI}    ${FAI_DEV_INFO_SUB_DATA}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    DevInfoSubscription
    Check HTTP Response Header Contains    Location
    Check Result Contains    ${response['body']['DevInfoSubscription']}    subscriptionType    DevInfoSubscription

    # TODO: how to wait for a timeout of (NOW_PLUS_X_SECONDS - guard time)? which guard time value to use?
    # and
    # // MEC 029, clause 5.2.6.2
    # the IUT entity sends a vPOST containing
    # uri indicating value CALLBACK_URL
    # body containing
    # ExpiryNotification containing
    # expiryDeadline indicating value NOW_PLUS_X_SECONDS    // TODO: how to set this?
    # ;
    # ;
    # ;
    # to the MEC_APP entity


TP_MEC_SRV_FAIS_011_OK
    [Documentation]
    ...    Check that the IUT sends notifications on Fixed Access Information events
    ...    to a subscribed MEC Application
    ...
    ...    Reference    ETSI GS MEC 029 V2.1.1, clause 5.2.7

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    # TODO how to generate an event?
    # Initial conditions    with {
    # the IUT entity being_in idle_state and
    # the IUT entity having a subscriptions containing
    # subscriptionType indicating value "OnuAlarmSubscription",
    # callbackReference indicating value CALLBACK_URL
    # ;
    # }

    # // MEC 029, clause 5.2.7
    # Expected behaviour
    # ensure that {
    # when {
    # the IUT entity generates a onu_alarm_event
    # }
    # then {
    # // // MEC 029, clause 5.2.7
    # the IUT entity sends a vPOST containing
    # Uri set to CALLBACK_URL
    # body containing
    # OnuAlarmSubscription containing
    # notificationType set to "OnuAlarmSubscription"
    # ;
    # ;
    # ;
    # to the MEC_APP entity
    # }
    # }
