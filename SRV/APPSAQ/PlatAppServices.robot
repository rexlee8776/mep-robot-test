*** Settings ***

Documentation
...   A test suite for validating Application Service Availability Query (APPSAQ) operations.

Resource    ../../resources/GenericKeywords.robot

Default Tags    TP_MEC_SRV_APPSAQ


*** Variables ***


*** Test Cases ***

Get the available MEC services for a given application instance
    [Documentation]
    ...   Check that the IUT responds with a list of available MEC services
    ...   for a given application instance when queried by a MEC Application
    ...
    ...   Reference   ETSI GS MEC 011 V2.0.8, clause 7.15.3.1
    ...   OpenAPI     https://forge.etsi.org/gitlab/mec/gs011-app-enablement-api/blob/master/Mp1.yaml#/definitions/ServiceInfo

    [Tags]      TP_MEC_SRV_APPSAQ_001_OK    TP_MEC_SRV_APPSAQ_BV

    Given the Plaform IUT has a MEC Application instantiated
    Log    MEC 011, clause 5.2.5
#    When the Plaform IUT entity receives a vGET for   /mec_service_mgmt/v1/applications/${APP_INSTANCE_ID}/services
    When the Plaform IUT entity receives a vGET for   /${APP_INSTANCE_ID}/services
    Log    MEC 011, clause 7.15.3.1
    Then the Plaform IUT sends a response   200   ServiceInfoList


MEC Applications sends incorrect parameters in request
    [Documentation]
    ...   Check that the IUT responds with an error when
    ...   a request with incorrect parameters is sent by a MEC Application
    ...
    ...   Reference   ETSI GS MEC 011 V2.0.8, clause 7.15.3.1

    [Tags]      TP_MEC_SRV_APPSAQ_001_BR    TP_MEC_SRV_APPSAQ_BI

    Given the Plaform IUT has a MEC Application instantiated
    Log    MEC 011, clause 5.2.5
    Log     Wrong parameter name should trigger an error response.
#    When the Plaform IUT entity receives a vGET for   /mec_service_mgmt/v1/applications/${APP_INSTANCE_ID}/services?instance_id=some_instance_id
    When the Plaform IUT entity receives a vGET for   /${APP_INSTANCE_ID}/services?instance_id=some_instance_id
    Log    MEC 011, clause 7.15.3.1
    Then the Plaform IUT sends a response   400   ProblemDetails


New MEC Applications service registration
    [Documentation]
    ...   Check that the IUT notifies the authorised relevant (subscribed) application
    ...   instances when a new service for a given application instance is registered
    ...
    ...   Reference   ETSI GS MEC 011 V2.0.8, clause 7.15.3.4

    [Tags]      TP_MEC_SRV_APPSAQ_002_OK    TP_MEC_SRV_APPSAQ_BV

    Given the Plaform IUT has a MEC Application instantiated
    # TODO where does the __some_service__ data comes from?
    Given a MEC Application subscribed to service notifications for    __some_service__
    Log    MEC 011, clause 5.2.4
    Log     Wrong parameter name should trigger an error response.
    # TODO where does the __some_data__ comes from?
#    When the Plaform IUT entity receives a vPOST for   /mec_service_mgmt/v1/applications/${APP_INSTANCE_ID}/services
    When the Plaform IUT entity receives a vPOST for    /${APP_INSTANCE_ID}/services    __some_data__    ServiceInfo
    Log    MEC 011, clause 7.15.3.4
    Then the Plaform IUT sends a response   201   ServiceInfo
    And the Plaform IUT response header parameter    Location    __location__
    Log    MEC 011, clause 6.4.2
    And the Plaform IUT sends a notification message to the subscribed MEC Applications with     ServiceAvailabilityNotification
