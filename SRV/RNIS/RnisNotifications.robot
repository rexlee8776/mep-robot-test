''[Documentation]   robot --outputdir ../../outputs ./RnisNotifications_BV.robot
...    Test Suite to validate RNIS/Notification (RNIS) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../pics.txt
Resource    ../../GenericKeywords.robot
Resource    resources/RadioNetworkInformationAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false
Library     BuiltIn
Library     OperatingSystem
Library     MockServerLibrary


*** Test Cases ***
Cell change notification
    [Documentation]   TC_MEC_SRV_RNIS_001_OK
    ...  Check that the RNIS service sends an RNIS notification about cell change if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.0.4, clause 6.4.2
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/RadioNetworkInformationAPI.schema.json
    Log  Creating mock request and response to handle Cell change notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/cell_change    body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=    Create Mock Response    headers="Content-Type: application/json"    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


RAB Establishment notification
    [Documentation]   TC_MEC_SRV_RNIS_002_OK
    ...  Check that the RNIS service sends an RNIS notification about RAB establishment if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.0.4, clause 6.4.3
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/RadioNetworkInformationAPI.schema.json
    Log  Creating mock request and response to handle RAB establishment notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/rab_est    body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=    Create Mock Response    headers="Content-Type: application/json"    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


RAB modification notification
    [Documentation]   TC_MEC_SRV_RNIS_003_OK
    ...  Check that the RNIS service sends an RNIS notification about RAB modification if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.0.4, clause 6.4.4
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/RadioNetworkInformationAPI.schema.json
    Log  Creating mock request and response to handle RAB modification notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/rab_mod    body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=    Create Mock Response    headers="Content-Type: application/json"    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


RAB release notification
    [Documentation]   TC_MEC_SRV_RNIS_004_OK
    ...  Check that the RNIS service sends an RNIS notification about RAB release if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.0.4, clause 6.4.5
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/RadioNetworkInformationAPI.schema.json
    Log  Creating mock request and response to handle RAB release notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/rab_rel    body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=    Create Mock Response    headers="Content-Type: application/json"    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


UE measurement notification
    [Documentation]   TC_MEC_SRV_RNIS_005_OK
    ...  Check that the RNIS service sends an RNIS notification about UE measurement report  if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.0.4, clause 6.4.6
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/RadioNetworkInformationAPI.schema.json
    Log  Creating mock request and response to handle UE measurement notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/MeasRepUeNotification    body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=    Create Mock Response    headers="Content-Type: application/json"    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


UE timing advance notification
    [Documentation]   TC_MEC_SRV_RNIS_006_OK
    ...  Check that the RNIS service sends an RNIS notification about UE timing advance if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.0.4, clause 6.4.7
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/RadioNetworkInformationAPI.schema.json
    Log  Creating mock request and response to handle UE timing advance notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/MeasTaNotification    body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=    Create Mock Response    headers="Content-Type: application/json"    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


UE carrier aggregation reconfiguration notification
    [Documentation]   TC_MEC_SRV_RNIS_007_OK
    ...  Check that the RNIS service sends an RNIS notification about UE carrier aggregation reconfiguration if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.0.4, clause 6.4.8
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/RadioNetworkInformationAPI.schema.json
    Log  Creating mock request and response to handle UE carrier aggregation reconfiguration notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/CaReconfSubscription    body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=    Create Mock Response    headers="Content-Type: application/json"    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


S1-U bearer notification
    [Documentation]   TC_MEC_SRV_RNIS_008_OK
    ...  Check that the RNIS service sends an RNIS notification about S1-U bearer if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.0.4, clause 6.4.10
    ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/RadioNetworkInformationAPI.schema.json
    Log  Creating mock request and response to handle UE S1-U bearer notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/S1BearerSubscription    body_type="JSON_SCHEMA"    body=${json}
    &{rsp}=    Create Mock Response    headers="Content-Type: application/json"    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


*** Keywords ***
