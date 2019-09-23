*** Settings ***

Documentation
...    A test suite for validating UE Distance Lookup (UEDISTLOOK) operations.

Resource    ../../GenericKeywords.robot

Default Tags    TP_MEC_SRV_UEDISTLOOK


*** Variables ***


*** Test Cases ***

TP_MEC_SRV_UEDISTLOOK_001_OK
    [Documentation]
    ...    Check that the IUT responds with the distance to a UE
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.0.3, clause 7.3.9
    ...    OpenAPI    # TODO check this

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_UE_LOC_QRY_URI}?address=${LOC_QRY_UE_ADDRESS}&latitude=${LOC_QRY_UE_LAT}&longitude=${LOC_QRY_UE_LONG}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    terminalDistance


TP_MEC_SRV_UEDISTLOOK_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 013 V2.0.3, clause 7.3.9

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_UE_LOC_QRY_URI}?address=${LOC_QRY_UE_ADDRESS}&lat=${LOC_QRY_UE_LAT}&longitude=${LOC_QRY_UE_LONG}
    Check HTTP Response Status Code Is    400
