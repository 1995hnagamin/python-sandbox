*** Settings ***
Library         Collections
Library         OperatingSystem
Library         Process
Library         RequestsLibrary
Suite Setup     サーバーを起動する
Suite Teardown  サーバーを停止する
Test Setup      テストサーバー用のセッションを作成する

*** Keywords ***
サーバーを起動する
    Start Process   pipenv  run     python  server/run.py   stdout=stdout.log   stderr=stderr.log
    Process Should Be Running
    Sleep   3s

サーバーを停止する
    Terminate Process

テストサーバー用のセッションを作成する
    Create Session  server  http://localhost:8080

*** Test Cases ***
`/` にアクセスすると200が返ってくる
    ${resp}=    Get Request     server  /
    Should Be Equal As Strings  ${resp.status_code}     200

`/images` にアクセスするとJSONが返ってくる
    ${resp}=    Get Request     server  /images
    Should Be Equal As Strings  ${resp.status_code}     200

`/upload` でファイルをアップロードできる
    ${file_data}=   Get Binary File     ${CURDIR}${/}earth.jpg
    ${files}=   Create Dictionary   image=${file_data}
    ${resp}=    Post Request    server  /upload     files=${files}
    Should Be Equal As Strings  ${resp.status_code}     200
    Log     Response is ${resp.content}     formatter=repr
    ${result}=  To Json     ${resp.content}
    Should Be Equal As Strings   ${result['status']}     ok
    Dictionary Should Contain Key     ${result}     image_id
