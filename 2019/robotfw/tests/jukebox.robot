*** Settings ***
Library         Collections
Library         OperatingSystem
Library         Process
Library         RequestsLibrary
Suite Setup     ${START}
Suite Teardown  ${STOP}
Test Setup      テストサーバー用のセッションを作成する

*** Variables ***
${username}         janedoe
${password}         p4ssw0rd
${wrong_password}   wrongpassword

*** Keywords ***
Start Server
    Start Process   pipenv  run     python  server/run.py   stdout=stdout.log   stderr=stderr.log
    Process Should Be Running
    Sleep   3s

Stop Server
    Terminate Process

テストサーバー用のセッションを作成する
    [Arguments]     ${uname}=${username}    ${pass}=${password}
    ${user}=  Create List     ${uname}   ${pass}
    Create Session  server  http://localhost:8080   auth=${user}

earth.jpg をアップロードする
    ${file_data}=   Get Binary File     ${CURDIR}${/}earth.jpg
    ${files}=   Create Dictionary   image=${file_data}
    ${resp}=    Post Request    server  /upload     files=${files}
    Return From Keyword     ${resp}

*** Test Cases ***
`/` にアクセスすると200が返ってくる
    ${resp}=    Get Request     server  /
    Should Be Equal As Strings  ${resp.status_code}     200

`/images` にアクセスするとJSONが返ってくる
    ${resp}=    Get Request     server  /images
    Should Be Equal As Strings  ${resp.status_code}     200

誤ったパスワードで `/images` にアクセスすることはできない
    [Setup]     テストサーバー用のセッションを作成する  pass=${wrong_password}
    ${resp}=    Get Request     server  /images
    Should Be Equal As Strings  ${resp.status_code}     401

`/upload` でファイルをアップロードできる
    ${resp}=    earth.jpg をアップロードする
    Should Be Equal As Strings  ${resp.status_code}     200
    Log     Response is ${resp.content}     formatter=repr
    ${result}=  To Json     ${resp.content}
    Should Be Equal As Strings   ${result['status']}     ok
    Dictionary Should Contain Key     ${result}     image_id

`/upload` でアップロードした画像は `/raw` からアクセスできる
    ${resp}=    earth.jpg をアップロードする
    Should Be Equal As Strings  ${resp.status_code}     200
    ${result}=  To Json     ${resp.content}
    Should Be Equal As Strings  ${result['status']}     ok
    Dictionary Should Contain Key     ${result}     image_id
    ${resp}=    Get Request     server  /raw/${result['image_id']}
    Should Be Equal As Strings  ${resp.status_code}     200
