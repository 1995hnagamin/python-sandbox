*** Settings ***
Library         Process
Library         RequestsLibrary
Suite Setup     サーバーを起動する
Suite Teardown  サーバーを停止する

*** Keywords ***
サーバーを起動する
    Start Process   pipenv      run     python      server/run.py   stdout=stdout.log   stderr=stderr.log
    Process Should Be Running
    Sleep   3s

サーバーを停止する
    Terminate Process

*** Test Cases ***
`/` にアクセスすると200が返ってくる
    Create Session              server                  http://localhost:8080
    ${resp}=                    Get Request             server                  /
    Should Be Equal As Strings  ${resp.status_code}     200

`/images` にアクセスするとJSONが返ってくる
    Create Session              server                  http://localhost:8080
    ${resp}=                    Get Request             server                  /images
    Should Be Equal As Strings  ${resp.status_code}     200
