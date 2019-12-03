*** Settings ***
Library         Process
Library         RequestsLibrary
Suite Setup     サーバーを起動する
Suite Teardown  サーバーを停止する
Test Setup      テストサーバー用のセッションを作成する

*** Keywords ***
サーバーを起動する
    Start Process   pipenv      run     python      server/run.py   stdout=stdout.log   stderr=stderr.log
    Process Should Be Running
    Sleep   3s

サーバーを停止する
    Terminate Process

テストサーバー用のセッションを作成する
    Create Session              server                  http://localhost:8080

*** Test Cases ***
`/` にアクセスすると200が返ってくる
    ${resp}=                    Get Request             server                  /
    Should Be Equal As Strings  ${resp.status_code}     200

`/images` にアクセスするとJSONが返ってくる
    ${resp}=                    Get Request             server                  /images
    Should Be Equal As Strings  ${resp.status_code}     200
