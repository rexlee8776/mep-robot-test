*** Settings ***

Documentation
...    A test suite for validating Timing capabilities (TIME) operations.

Resource    ../../GenericKeywords.robot

Default Tags    TP_MEC_SRV_TIME


*** Variables ***


*** Test Cases ***

TP_MEC_SRV_TIME_001_OK
    [Documentation]
    ...    Check that the IUT responds with timing capabilities
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.7.3.1
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.8/Mp1.yaml#/definitions/TimingCaps

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_ME_APP_SUPPORT_TIMING_CAPS_URI}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    TimingCaps


TP_MEC_SRV_TIME_002_OK
    [Documentation]
    ...    Check that the IUT responds with current time
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.8.3.1
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.8/Mp1.yaml#/definitions/CurrentTime

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_ME_APP_SUPPORT_TIMING_CURRENT_URI}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    CurrentTime
