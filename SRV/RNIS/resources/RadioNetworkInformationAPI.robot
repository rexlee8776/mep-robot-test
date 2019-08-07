*** Settings ***
Resource    ../environment/variables.txt
Resource    ../environment/pics.txt
Resource    GenericKeywords.robot
Library    REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false
Library    JSONSchemaLibrary    schemas/


*** Keywords ***
