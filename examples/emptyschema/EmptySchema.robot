*** Settings ***
Library     BuiltIn
Library     OperatingSystem
Library    JSONSchemaLibrary    schemas/



*** Test Cases ***
Testing Empty Schema Validation
    ${object}=    Get File    jsons/test.json
    ${json}=	Evaluate	json.loads('''${object}''')	json
    Validate Json    EmptySchema.json    ${json}
