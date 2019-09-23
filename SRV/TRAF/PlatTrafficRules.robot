*** Settings ***

Documentation
...    A test suite for validating Traffic rules (TRAF) operations.

Resource    ../../GenericKeywords.robot

Default Tags    TP_MEC_SRV_TRAF


*** Variables ***


*** Test Cases ***

TP_MEC_SRV_TRAF_001_OK
    [Documentation]
    ...    Check that the IUT responds with a list of available traffic rules
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.10.3.1
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.8/Mp1.yaml#/definitions/TrafficRule

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/traffic_rules
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    TrafficRuleList


TP_MEC_SRV_TRAF_001_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.10.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_ME_APP_SUPPORT_URI}/${NON_EXISTENT_APP_INSTANCE_ID}/traffic_rules
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_TRAF_002_OK
    [Documentation]
    ...    Check that the IUT responds with the information on a specific traffic rule
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.11.3.1
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.8/Mp1.yaml#/definitions/TrafficRule

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/traffic_rules/${TRAFFIC_RULE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    TrafficRule
    Check Result Contains    ${response['body']['TrafficRule']}    trafficRuleId    ${TRAFFIC_RULE_ID}


TP_MEC_SRV_TRAF_003_OK
    [Documentation]
    ...    Check that the IUT updates a specific traffic rule
    ...    when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.11.3.2
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.8/Mp1.yaml#/definitions/TrafficRule

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/traffic_rules/${TRAFFIC_RULE_ID}    ${MEC_APP_TRAF_DATA}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    TrafficRule
    Check Result Contains    ${response['body']['TrafficRule']}    trafficRuleId    ${TRAFFIC_RULE_ID} 
    Check Result Contains    ${response['body']['TrafficRule']}    action    "DROP"


TP_MEC_SRV_TRAF_003_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.11.3.2
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.8/Mp1.yaml#/definitions/TrafficRule

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/traffic_rules/${TRAFFIC_RULE_ID}    ${MEC_APP_TRAF_DATA_BR}
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_TRAF_003_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.11.3.2
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.8/Mp1.yaml#/definitions/TrafficRule

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/traffic_rules/${TRAFFIC_RULE_ID}    ${NON_EXISTENT_TRAFFIC_RULE_ID}
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_TRAF_003_PF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request sent by a MEC Application doesn't comply with a required condition
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.11.3.2
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.8/Mp1.yaml#/definitions/TrafficRule

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT invalid e-tag    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/traffic_rules/${TRAFFIC_RULE_ID}    ${MEC_APP_TRAF_DATA}
    Check HTTP Response Status Code Is    412

