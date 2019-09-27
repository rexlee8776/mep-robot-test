*** Settings ***

Documentation
    ...   A resource file with reusable keywords and variables.
    ...
    ...   The system specific keywords created here form our own domain specific language.


Library     REST    ${MEC_SERVER_IUT}   ssl_verify=${MEC_SERVER_SSL_VERITY}     accept=application/json     content_type=application/json
Library     JSONSchemaLibrary    ${JSONS_SCHEMAS}


*** Keywords ***

GET URI
    [Arguments]         ${service}

    [Documentation]
    ...     Issue a GET request to an URI.
    ...         NOTE: the response is stored in the REST library used and is available throughtout the test scope.
    ...
    ...       service: the service endpoint to call (without the server name or port).

    Log     URI: ${service}
    GET     ${service}


the Plaform IUT entity receives a vGET for
    [Arguments]         ${endpoint}

    [Documentation]
    ...   Send a GET request to an API endpoint.
    ...
    ...     endpoint: the absolut path to the API endpoint to reach, without the server address and port.

    ${resp} =   GET URI     ${endpoint}


the Plaform IUT entity receives a vPOST for
    [Arguments]    ${endpoint}    ${data}    ${schema}

    [Documentation]
    ...    A MEC Application subscribes notifications on the availability of a specific service.
    ...
    ...    endpoint: the absolut path to the API endpoint to reach, without the server address and port.
    ...    data_schema: the schema for the expected data in the POST request.

    Validate Json    ${schema}.schema.json    ${data}
    # TODO will this be mocked or will we use the proper MEC API calls for this?
    # If so, won't theses tests require a functional MEC Server?


the Plaform IUT sends a response
    [Arguments]   ${status_code}   ${json_schema}

    [Documentation]
    ...     Check the correctness of the response sent by the IUT.
    ...
    ...       status_code: The expected HTTP status code received in the response.
    ...       json_schema: the schema to validate the response conformance.

    Integer     response status           ${status_code}
    Output    response
    ${response} =    Output    response body
    Validate Json    ${json_schema}.schema.json    ${response}

    
the Plaform IUT has a MEC Application instantiated
    [Documentation]
    ...   Instantiates a MEC Application.
    
    # TODO will this be mocked or will we use the proper MEC API calls for this?
    # If so, won't theses tests require a functional MEC Server?
    Set Suite Variable  ${APP_INSTANCE_ID}    123


a MEC Application subscribed to service notifications for 
    [Arguments]         ${mec_service}

    [Documentation]
    ...     A MEC Application subscribes notifications on the availability of a specific service.
    ...
    ...       mec_service: the MEC platform service a MEC Application wants to be notified of.

    Log     Available MEC Service: ${mec_service}
    # TODO will this be mocked or will we use the proper MEC API calls for this?
    # If so, won't theses tests require a functional MEC Server?


the Plaform IUT response header parameter
    [Arguments]    ${header}    ${value}

    [Documentation]
    ...    

    # TODO the platform must reply with a specific header which should be checked for conformance.
    # How to do this as the test needs to send a response but also ensure it sends the proper header?
    
    # String request headers Authorization Bearer ${oauth_token}
    No Operation


the Plaform IUT sends a notification message to the subscribed MEC Applications with
    [Arguments]    ${data}

    [Documentation]
    ...    

    # TODO
    # GS MEC 011 V2.0.8, §5.2.4: the MEC platform identifies the relevant MEC platforms for this update, and informs
    # them about the changes in service availability by means that may be outside the scope of the present document.
    #
    # The TP has this notification, so what to do here? Simply do not care about this? Update the TP to exclude this notification? 
    
    No Operation

