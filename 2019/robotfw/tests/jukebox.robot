*** Settings ***
Library         REST            http://localhost:8080

*** Test Cases ***
`/` returns 200
        GET             /
        Integer         response status         200
