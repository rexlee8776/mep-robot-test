*** Settings ***

Documentation
...    A test suite for validating Service Availability Query (SAQ) operations.

Resource    ../../GenericKeywords.robot

Default Tags    TP_MEC_SRV_SAQ


*** Variables ***


*** Test Cases ***

TP_MEC_SRV_SAQ_001_OK
    [Documentation]
    ...    Check that the IUT responds with a list of available MEC services
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.8, clause 7.4.3.1
    ...    OpenAPI    https://forge.etsi.org/gitlab/mec/gs011-app-enablement-api/blob/master/Mp1.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_MEC_SVC_MGMT_SVC_URI}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceInfoList


TP_MEC_SRV_SAQ_001_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.8, clause 7.4.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_MEC_SVC_MGMT_SVC_URI}?instance_id=__any_value__
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_SAQ_002_OK
    [Documentation]
    ...    Check that the IUT responds with the information on a specific DNS rule
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.13.3.1
    ...    OpenAPI    https://forge.etsi.org/gitlab/mec/gs011-app-enablement-api/blob/master/Mp1.yaml#/definitions/DnsRule

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_MEC_SVC_MGMT_SVC_URI}/${SERVICE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceInfoList
    Check Result Contains    ${response['body']['ServiceInfoList']}    serInstanceId    ${SERVICE_ID}


TP_MEC_SRV_SAQ_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.8, clause 7.3.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_MEC_SVC_MGMT_SVC_URI}/${NON_EXISTENT_SERVICE_ID}
    Check HTTP Response Status Code Is    404
