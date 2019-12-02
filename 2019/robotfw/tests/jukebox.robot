*** Settings ***
Library         Process
Library         REST            http://localhost:8080
Test Setup      サーバーを起動する
Test Teardown   サーバーを停止する

*** Keywords ***
サーバーを起動する
    Start Process   pipenv      run     python      server/run.py   stdout=stdout.log   stderr=stderr.log
    Process Should Be Running

サーバーを停止する
    Terminate Process

*** Test Cases ***
`/` にアクセスすると200が返ってくる
    GET         /
    Integer     response status         200
