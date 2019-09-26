*** Settings ***

Documentation
...    A test suite for validating DNS rules (DNS) operations.

Resource    ../../GenericKeywords.robot

Default Tags    TP_MEC_SRV_DNS


*** Variables ***


*** Test Cases ***

TP_MEC_SRV_DNS_001_OK
    [Documentation]
    ...    Check that the IUT responds with a list of active DNS rules
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.2.9.3.1
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.9/MecAppSupportApi.yaml#/definitions/DnsRule

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/dns_rules
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    DnsRuleList


TP_MEC_SRV_DNS_002_OK
    [Documentation]
    ...    Check that the IUT responds with the information on a specific DNS rule
    ...    when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.2.10.3.1
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.9/MecAppSupportApi.yaml#/definitions/DnsRule

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/dns_rules/${DNS_RULE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    DnsRule
    Check Result Contains    ${response['body']['DnsRule']}    dnsRuleId    ${DNS_RULE_ID}


TP_MEC_SRV_DNS_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.2.10.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/dns_rules/${NON_EXISTENT_DNS_RULE_ID}
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_DNS_003_OK
    [Documentation]
    ...    Check that the IUT updates a specific DNS rule
    ...    when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.2.10.3.2
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.9/MecAppSupportApi.yaml#/definitions/DnsRule

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/dns_rules/${DNS_RULE_ID}    ${MEC_APP_DNSRULE_UPDT_DATA}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    DnsRule
    Check Result Contains    ${response['body']['DnsRule']}    dnsRuleId    ${DNS_RULE_NAME}
    Check Result Contains    ${response['body']['DnsRule']}    ipAddress    ${SOME_IP_ADDRESS}


TP_MEC_SRV_DNS_003_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.2.10.3.2
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.9/MecAppSupportApi.yaml#/definitions/DnsRule

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/dns_rules/${DNS_RULE_ID}    ${MEC_APP_DNSRULE_UPDT_DATA_BR}
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_DNS_003_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.2.10.3.2
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.9/MecAppSupportApi.yaml#/definitions/DnsRule

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/dns_rules/${NON_EXISTENT_DNS_RULE_ID}    ${MEC_APP_DNSRULE_UPDT_DATA}
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_DNS_003_PF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request sent by a MEC Application doesn't comply with a required condition
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 7.2.10.3.2
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.9/MecAppSupportApi.yaml#/definitions/DnsRule

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT invalid e-tag    /${PX_ME_APP_SUPPORT_URI}/${APP_INSTANCE_ID}/dns_rules/${DNS_RULE_ID}    ${MEC_APP_DNSRULE_UPDT_DATA}
    Check HTTP Response Status Code Is    412

