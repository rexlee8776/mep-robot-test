*** Settings ***

Documentation
...    A test suite for validating Radio Node Location Lookup (RLOCLOOK) operations.

Resource    ../../GenericKeywords.robot

Default Tags    TP_MEC_SRV_RLOCLOOK


*** Variables ***


*** Test Cases ***

TP_MEC_SRV_RLOCLOOK_001_OK
    [Documentation]
    ...    Check that the IUT responds with the list of radio nodes currently associated with the MEC host and the location of each radio node
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.0.3, clause 7.3.7
    ...    OpenAPI    https://forge.etsi.org/gitlab/mec/gs013-location-api/blob/master/LocationAPI.yaml#/definitions/AccessPointList

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_ME_APP_Q_ZONE_ID_URI}/${ZONE_ID}/accessPoints
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    accessPointList
    Check Result Contains    ${response['body']['accessPointList']}    zoneId    ${ZONE_ID}


TP_MEC_SRV_RLOCLOOK_001_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.0.3, clause 7.3.7

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_ME_APP_Q_ZONE_ID_URI}/${NON_EXISTENT_ZONE_ID}/accessPoints
    Check HTTP Response Status Code Is    404
