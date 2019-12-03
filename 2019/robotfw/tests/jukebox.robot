*** Settings ***
Library         Collections
Library         OperatingSystem
Library         Process
Library         RequestsLibrary
Suite Setup     サーバーを起動する
Suite Teardown  サーバーを停止する
Test Setup      テストサーバー用のセッションを作成する

*** Variables ***
${username}         janedoe
${password}         p4ssw0rd
${wrong_password}   wrongpassword

*** Keywords ***
サーバーを起動する
    Start Process   pipenv  run     python  server/run.py   stdout=stdout.log   stderr=stderr.log
    Process Should Be Running
    Sleep   3s

サーバーを停止する
    Terminate Process

テストサーバー用のセッションを作成する
    ${user}=  Create List     ${username}   ${password}
    Create Session  server  http://localhost:8080   auth=${user}

パスワードを間違える
    ${user}=  Create List     ${username}   ${wrong_password}
    Create Session  server  http://localhost:8080   auth=${user}

*** Test Cases ***
`/` にアクセスすると200が返ってくる
    ${resp}=    Get Request     server  /
    Should Be Equal As Strings  ${resp.status_code}     200

`/images` にアクセスするとJSONが返ってくる
    ${resp}=    Get Request     server  /images
    Should Be Equal As Strings  ${resp.status_code}     200

誤ったパスワードで `/images` にアクセスすることはできない
    [Setup]     パスワードを間違える
    ${resp}=    Get Request     server  /images
    Should Be Equal As Strings  ${resp.status_code}     403

`/upload` でファイルをアップロードできる
    ${file_data}=   Get Binary File     ${CURDIR}${/}earth.jpg
    ${files}=   Create Dictionary   image=${file_data}
    ${resp}=    Post Request    server  /upload     files=${files}
    Should Be Equal As Strings  ${resp.status_code}     200
    Log     Response is ${resp.content}     formatter=repr
    ${result}=  To Json     ${resp.content}
    Should Be Equal As Strings   ${result['status']}     ok
    Dictionary Should Contain Key     ${result}     image_id
