*** Settings ***
Library         REST            http://localhost:8080

*** Test Cases ***
Root discovery returns 200
        GET             /.well-known/host-meta
        Integer         response status         200
