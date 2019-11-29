*** Settings ***
Library		Process
Library		REST		http://localhost:8080
Test Setup	Start server

*** Keywords ***
Start server
        Start Process	pipenv	run	python	server/run.py	stdout=stdout.log	stderr=stderr.log
        Process Should Be Running

*** Test Cases ***
`/` returns 200
        GET		/
        Integer		response status		200
