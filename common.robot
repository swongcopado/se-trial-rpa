*** Settings ***
Library                         QWeb
Library                         QForce
Library                         String
Library                         Collections


*** Variables ***
${BROWSER}                      chrome
${sf_domain}                     ${se_id}${trial_no}                                     # domain is in the format of <se_id><trial_no>. E.g. swong30
${sf_user}                       ${se_id}+${trial_no}@copado.com                         # username for our trial org should be in the format <se_id>+<trial_no>@copado.com. E.g. swong+30@copado.com
${login_url}                    https://${sf_domain}.my.salesforce.com/                  # Salesforce instance. NOTE: Should be overwritten in CRT variables
${home_url}                     ${login_url}/lightning/page/home
${dummy_password}               1234abcd!

*** Keywords ***
Setup Browser
    Open Browser                about:blank                 ${BROWSER}
    Set Library Search Order    QForce                      QWeb
    SetConfig                   LineBreak                   ${EMPTY}                    #\ue000
    SetConfig                   DefaultTimeout              60s                         #sometimes salesforce is slow
    Login

End suite
    Close All Browsers

Login
    [Documentation]             Login to Salesforce instance
    GoTo                        ${login_url}
    TypeText                    Username                    ${sf_user}
    TypeSecret                  Password                    ${sf_password}
    ClickText                   Log In
    ${phoneRegPrompt}        IsText                      Register Your Mobile Phone
    IF                          ${phoneRegPrompt}
        ClickText               I Don't Want to Register My Phone
    END
    ${scheduledMaintenance}     IsText                   Scheduled Maintenance
    IF                        ${scheduledMaintenance}
        ClickText             Got it
    END


Home
    [Documentation]             Navigate to homepage, login if needed
    GoTo                        ${home_url}
    ${login_status} =           IsText                      To access this page, you have to log in to Salesforce.    2
    Run Keyword If              ${login_status}             Login
    VerifyText                  Home

Login As
    [Documentation]             Login to Salesforce instance
    [Arguments]                 ${pUsername}    ${pPassword}
    GoTo                        ${login_url}
    TypeText                    Username                    ${pUsername}
    TypeSecret                  Password                    ${pPassword}
    ClickText                   Log In
    ${phoneRegPrompt}        IsText                      Register Your Mobile Phone
    IF                          ${phoneRegPrompt}
        ClickText               I Don't Want to Register My Phone
    END
    ${scheduledMaintenance}     IsText                      Scheduled Maintenance
    IF                        ${scheduledMaintenance}
        ClickText             Got it
    END


Login To Sandbox As
    [Documentation]             Login to Salesforce instance
    [Arguments]                 ${sandboxName}    ${pUsername}    ${pPassword}
    GoTo                        ${sf_domain}--${sandboxName}.my.salesforce.com
    TypeText                    Username                    ${pUsername}
    TypeSecret                  Password                    ${pPassword}
    ClickText                   Log In
    ${phoneRegPrompt}        IsText                      Register Your Mobile Phone
    IF                          ${phoneRegPrompt}
        ClickText               I Don't Want to Register My Phone
    END
    ${scheduledMaintenance}     IsText                      Scheduled Maintenance
    IF                        ${scheduledMaintenance}
        ClickText             Got it
    END

Logout
    ${isLoggedIn}    IsNoText    Remember me
    IF                ${isLoggedIn}
        ClickText     View Profile
        ClickText     Log Out
        VerifyText    Remember me    
    END
    Sleep             5s