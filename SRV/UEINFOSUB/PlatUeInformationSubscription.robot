*** Settings ***

Documentation
...    A test suite for validating UE Information Subscription (UEINFOSUB) operations.

Resource    ../../GenericKeywords.robot

Default Tags    TP_MEC_SRV_UEINFOSUB


*** Variables ***


*** Test Cases ***

TP_MEC_SRV_UEINFOSUB_001_OK
    [Documentation]
    ...    Check that the IUT acknowledges the UE information change subscription request
    ...    when commanded by a MEC Application and notifies it when the location changes
    ...
    ...    Reference    ETSI GS MEC 013 V2.0.3, clause 7.3.5
    ...    OpenAPI    https://forge.etsi.org/gitlab/mec/gs013-location-api/blob/master/LocationAPI.yaml#/definitions/zonalTrafficSubscription

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPOST    /${PX_UE_INFO_SUB_URI}    ${UE_ZONAL_TRF_SUB_DATA}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    zonalTrafficSubscription
    Check Result Contains    ${response['body']['zonalTrafficSubscription']}    clientCorrelator    ${ZONAL_TRF_SUB_CLIENT_ID}
    Check Result Contains    ${response['body']['zonalTrafficSubscription']}    callbackReference    ${ZONAL_TRF_NOTIF_CALLBACK_URI}
    Check Result Contains    ${response['body']['zonalTrafficSubscription']}    zoneId    ${ZONAL_TRF_ZONE_ID}
    
    # TODO how to send this? The TP has the IUT doing this immediately. Do we want this or will it be discarded as part of the test?
    # // MEC 013, clause 7.3.5.3
    # the IUT entity sends a vPOST containing
    # Uri set to CALLBACK_URL 
    # body containing
    # zonalPresenceNotification containing
    # clientCorrelator set to CLIENT_ID, 
    # zoneId indicating value ZONE_ID
    # ;
    # ;
    # ;
    # to the MEC_APP entity


TP_MEC_SRV_UEINFOSUB_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.0.3, clause 7.3.5
    ...    OpenAPI    https://forge.etsi.org/gitlab/mec/gs013-location-api/blob/master/LocationAPI.yaml#/definitions/zonalTrafficSubscription

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPOST    /${PX_UE_ZONAL_TRF_SUB_URI}    ${UE_ZONAL_TRF_SUB_DATA_BR}
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_UEINFOSUB_002_OK
    [Documentation]
    ...    Check that the IUT acknowledges the cancellation of UE information change notifications
    ...    when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.0.3, clause 7.3.6

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vDELETE without e-tag    /${PX_UE_ZONAL_TRF_SUB_URI}/${SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    204


TP_MEC_SRV_UEDISTSUB_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.0.3, clause 7.3.6

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vDELETE without e-tag    /${PX_UE_ZONAL_TRF_SUB_URI}/${NON_EXISTING_SUBSCRIPTION_ID}
    Check HTTP Response Status Code Is    404


