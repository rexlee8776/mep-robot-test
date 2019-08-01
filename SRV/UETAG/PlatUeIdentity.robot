''[Documentation]   robot --outputdir ./outputs ./SRV/UETAG/PlatUeIdentity.robot
...    Test Suite to validate UE Identity Tag (UETAG) operations.

*** Settings ***
Resource    ../../environment/variables.txt
Resource    ../../resources/GenericKeywords.robot
Resource    ../../resources/UEidentityAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false

Default Tags    TC_MEC_SRV_UETAG

*** Variables ***


*** Test Cases ***
Get UE Identity Tag information
    [Documentation]   TC_MEC_SRV_UETAG_001_OK
    ...  Check that the IUT responds with the information on a UE Identity tag when queried by a MEC Application
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs014-ue-identity-api/blob/master/UEidentityAPI.yaml#/definitions/UeIdentityTagInfo

    [Tags]    TP_MEC_SRV_UETAG_001_OK    TP_MEC_SRV_UETAG

    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"Basic YWxhZGRpbjpvcGVuc2VzYW1l"}
    Set Headers    {"Content-Length":"0"}
    Get    /exampleAPI/ui/v1/${APP_INSTANCE_ID}/ue_identity_tag_info?ueIdentityTag=${UE_IDENTITY_TAG}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ueIdentityTagInfo
    #Log    Check ueIdentityTagsList for ${UE_IDENTITY_TAG} element
    Should Be Present In Json List    ${response['body']['ueIdentityTagInfo']['ueIdentityTags']}    ueIdentityTag    ${UE_IDENTITY_TAG}

Bad Request error on UE Identity Tag registration
# FIXME Which IE protocol should be invalid?
    [Documentation]   TC_MEC_SRV_UETAG_001_BR
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs014-ue-identity-api/blob/master/UEidentityAPI.yaml#/definitions/UeIdentityTagInfo

    [Tags]    TP_MEC_SRV_UETAG_001_BR    TP_MEC_SRV_UETAG

    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"Basic YWxhZGRpbjpvcGVuc2VzYW1l"}
    Set Headers    {"Content-Length":"0"}
    Get    /exampleAPI/ui/v1/${APP_INSTANCE_ID}/invalid/ue_identity_tag_info?ueIdentityTag=${UE_IDENTITY_TAG}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    400

Not Found error on UE Identity Tag registration
    [Documentation]   TC_MEC_SRV_UETAG_001_NF
    ...  Check that the IUT responds with an error when a request for an URI that cannot be mapped to a valid resource URI is sent by a MEC Application
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs014-ue-identity-api/blob/master/UEidentityAPI.yaml#/definitions/UeIdentityTagInfo

    [Tags]    TP_MEC_SRV_UETAG_001_NF    TP_MEC_SRV_UETAG

    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"Basic YWxhZGRpbjpvcGVuc2VzYW1l"}
    Set Headers    {"Content-Length":"0"}
    Get    /exampleAPI/ui/v1/${NON_EXISTENT_APP_INSTANCE_ID}/ue_identity_tag_info?ueIdentityTag=${UE_IDENTITY_TAG}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    404

Register a UE Identity Tag
    [Documentation]   TC_MEC_PLAT_UETAG_002_OK
    ...  Check that the IUT registers a tag (representing a UE) or a list of tags when commanded by a MEC Application
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.3.3.2
    ...  Reference https://forge.etsi.org/gitlab/mec/gs014-ue-identity-api/blob/master/UEidentityAPI.yaml#/definitions/UeIdentityTagInfo

    [Tags]    TP_MEC_SRV_UETAG_002_OK    TP_MEC_SRV_UETAG

    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"Basic YWxhZGRpbjpvcGVuc2VzYW1l"}
    # Preamble: Check that the user tag is not registered
    Check User Identity Tag state    ${UE_IDENTITY_TAG}    UNREGISTERED
    # Test Body: Register the tag user and check that the IUT has registered the tag user
    Post    /exampleAPI/ui/v1/${APP_INSTANCE_ID}/ue_identity_tag_info    {"ueIdentityTags":[{"ueIdentityTag":"${UE_IDENTITY_TAG}","state":"REGISTERED"}]}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check User Identity Tag state    ${UE_IDENTITY_TAG}    REGISTERED

Bad Request error on invalid state
    [Documentation]   TC_MEC_PLAT_UETAG_002_BR
    ...  Check that the IUT responds with an error when an unauthorised request is sent by a MEC Application
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.3.3.2
    ...  Reference https://forge.etsi.org/gitlab/mec/gs014-ue-identity-api/blob/master/UEidentityAPI.yaml#/definitions/UeIdentityTagInfo

    [Tags]    TP_MEC_SRV_UETAG_002_BR    TP_MEC_SRV_UETAG

    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"Basic YWxhZGRpbjpvcGVuc2VzYW1l"}
    # Test Body: Register the tag user and check that the IUT has registered the tag user
    Post    /exampleAPI/ui/v1/${APP_INSTANCE_ID}/ue_identity_tag_info    {"ueIdentityTags":[{"ueIdentityTag":"${UE_IDENTITY_TAG}","state":"INVALID_STATE"}]}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    400

Precondition Failed error on invalid state
    [Documentation]   TC_MEC_PLAT_UETAG_002_PF
    ...  Check that the IUT responds with ProblemDetails on information an invalid URI
    ...  Reference ETSI GS MEC 014 V1.1.1, clause 7.3.3.2
    ...  Reference https://forge.etsi.org/gitlab/mec/gs014-ue-identity-api/blob/master/UEidentityAPI.yaml#/definitions/UeIdentityTagInfo

    [Tags]    TP_MEC_SRV_UETAG_002_PF    TP_MEC_SRV_UETAG

    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"Basic YWxhZGRpbjpvcGVuc2VzYW1l"}
    # Test Body: Register the tag user and check that the IUT has registered the tag user
    Post    /exampleAPI/ui/v1/${APP_INSTANCE_ID}/ue_identity_tag_info    {"ueIdentityTags":[{"ueIdentityTag":"${UE_IDENTITY_TAG_INVALID_STATE}","state":"UNREGISTERED"}]}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    412
    # TODO Check ProblemDetails
