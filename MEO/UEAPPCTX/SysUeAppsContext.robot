''[Documentation]   robot --outputdir ../../outputs ./PlatBandwidthManager.robot
...    Test Suite to validate Bandwidth Management API (BWA) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../pics.txt
Resource    ../../GenericKeywords.robot
Resource    resources/UEAppInterfaceAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false



*** Test Cases ***


*** Keywords ***
