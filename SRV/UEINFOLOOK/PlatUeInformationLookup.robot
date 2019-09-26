*** Settings ***

Documentation
...    A test suite for validating UE Information Lookup (UEINFOLOOK) operations.

Resource    ../../GenericKeywords.robot

Default Tags    TP_MEC_SRV_UEINFOLOOK


*** Variables ***


*** Test Cases ***

TP_MEC_SRV_UEINFOLOOK_001_OK
    [Documentation]
    ...    Check that the IUT responds with the information pertaining to one or more UEs in a particular location
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.3
    ...    OpenAPI    https://forge.etsi.org/gitlab/mec/gs013-location-api/blob/master/LocationAPI.yaml#/definitions/UserList

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_UE_LOC_USERS_URI}?address=${ACR_SOME_IP}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    userList


TP_MEC_SRV_UEINFOLOOK_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.3

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_UE_LOC_USERS_URI}?addr=${ACR_SOME_IP}
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_UEINFOLOOK_001_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.1.1, clause 7.3.3
    ...    OpenAPI    https://forge.etsi.org/gitlab/mec/gs013-location-api/blob/master/LocationAPI.yaml#/definitions/UserList

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_UE_LOC_USERS_URI}?address=${ACR_UNKNOWN_IP}
    Check HTTP Response Status Code Is    400
