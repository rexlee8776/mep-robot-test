*** Settings ***

Documentation
...    A test suite for validating Application Service Availability Query (APPSAQ) operations.

Resource    ../../GenericKeywords.robot

Default Tags    TP_MEC_SRV_APPSAQ


*** Variables ***


*** Test Cases ***

TP_MEC_SRV_APPSAQ_001_OK
    [Documentation]
    ...    Check that the IUT responds with a list of available MEC services
    ...    for a given application instance when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 8.2.6.3.1
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.9/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_MEC_SVC_MGMT_APPS_URI}/${APP_INSTANCE_ID}/services
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceInfoList


TP_MEC_SRV_APPSAQ_001_BR
    [Documentation]
    ...   Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 8.2.6.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    # Wrong query parameter name should trigger an error response.
    vGET    /${PX_MEC_SVC_MGMT_APPS_URI}/${APP_INSTANCE_ID}/services?id=some_instance_id
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_APPSAQ_002_OK
    [Documentation]
    ...    Check that the IUT notifies the authorised relevant (subscribed) application
    ...    instances when a new service for a given application instance is registered
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 8.2.6.3.4
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.9/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPOST    /${PX_MEC_SVC_MGMT_APPS_URI}/${APP_INSTANCE_ID}/services    ${MEC_APP_NEW_SVC_DATA}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    ServiceInfo
    Check HTTP Response Header    Location    ${LOCATION_HEADER}
    Check Result Contains    ${response['body']['ServiceInfo']}    serName    ${SERVICE_NAME}
    Check Plaform IUT notifies the MEC Application instances    ServiceAvailabilityNotification


TP_MEC_SRV_APPSAQ_002_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 8.2.6.3.4
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.9/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPOST    /${PX_MEC_SVC_MGMT_APPS_URI}/${APP_INSTANCE_ID}/services    ${MEC_APP_NEW_SVC_DATA_BR}
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_APPSAQ_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 8.2.6.3.4
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.9/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPOST    /${PX_MEC_SVC_MGMT_APPS_URI}/${NON_EXISTENT_APP_INSTANCE_ID}/services    ${MEC_APP_NEW_SVC_DATA}
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_APPSAQ_003_OK
    [Documentation]
    ...    Check that the IUT responds with the information on a specific service
    ...    for a given application instance when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 8.2.7.3.1
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.9/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_MEC_SVC_MGMT_APPS_URI}/${APP_INSTANCE_ID}/services/${SERVICE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceInfo
    Check Result Contains    ${response['body']['ServiceInfo']}    serInstanceId    ${SERVICE_ID}


TP_MEC_SRV_APPSAQ_003_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 8.2.7.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vGET    /${PX_MEC_SVC_MGMT_APPS_URI}/${APP_INSTANCE_ID}/services/${NON_EXISTENT_SERVICE_ID}
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_APPSAQ_004_OK
    [Documentation]
    ...    Check that the IUT updates a service information for a given
    ...    application instance when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 8.2.7.3.2
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.9/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT    /${PX_MEC_SVC_MGMT_APPS_URI}/${APP_INSTANCE_ID}/services/${SERVICE_ID}    ${MEC_APP_SVC_UPDT_DATA}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceInfo
    Check Result Contains    ${response['body']['ServiceInfo']}    version    ${SVC_NEW_VERSION}


TP_MEC_SRV_APPSAQ_004_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 8.2.7.3.2
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.9/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT    /${PX_MEC_SVC_MGMT_APPS_URI}/${APP_INSTANCE_ID}/services/${SERVICE_ID}    ${MEC_APP_SVC_UPDT_DATA_BR}
    Check HTTP Response Status Code Is    400


TP_MEC_SRV_APPSAQ_004_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 8.2.7.3.2
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.9/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT    /${PX_MEC_SVC_MGMT_APPS_URI}/${APP_INSTANCE_ID}/services/${NON_EXISTENT_SERVICE_ID}    ${MEC_APP_SVC_UPDT_DATA}
    Check HTTP Response Status Code Is    404


TP_MEC_SRV_APPSAQ_004_PF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request sent by a MEC Application doesn't comply with a required condition
    ...
    ...    Reference    ETSI GS MEC 011 V2.0.9, clause 8.2.7.3.2
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/v2.0.9/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    vPUT invalid e-tag    /${PX_MEC_SVC_MGMT_APPS_URI}/${APP_INSTANCE_ID}/services/${SERVICE_ID}    ${MEC_APP_SVC_UPDT_DATA}
    Check HTTP Response Status Code Is    412



*** Keywords ***

Check Plaform IUT notifies the MEC Application instances
    [Documentation]
    ...    

    [Arguments]    ${instance_id}    ${content}

    # TODO check how to send the message (isn't defined). Does it need to be tested as it's not defined?
    
    # // MEC 011, clause 6.4.2
    # the IUT entity sends a notification_message containing
    # body containing
    # notificationType set to "SerAvailabilityNotification",
    # services containing
    # serName set to SERVICE_NAME
    # _links containing
    # subscription set to MP1_SUBSCRIPTION_A
    # ;
    # ;
    # ;
    # ;
    # to the MEC_APP_Subscriber entity
