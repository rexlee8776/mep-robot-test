*** Settings ***

Documentation
...    A test suite for validating Transport (TRANS) operations.

Resource    ../../GenericKeywords.robot

Default Tags    TP_MEC_SRV_TRANS


*** Variables ***


*** Test Cases ***

TP_MEC_SRV_TRANS_001_OK
    [Documentation]
    ...    Check that the IUT responds with a list of available transports
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.9.3.1
    ...    OpenAPI    https://forge.etsi.org/gitlab/mec/gs011-app-enablement-api/blob/master/Mp1.yaml#/definitions/TransportInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_ME_TRANSPORTS_MNGMT_URI}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    TransportInfoList
