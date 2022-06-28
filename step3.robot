*** Settings ***

Documentation                   Create Copado Credentials for all users
Resource                        ./common.robot
Suite Setup                     Setup Browser
Suite Teardown                  End suite

*** Variables ***
${sca_results_pmd_checkbox}                             page:console:j_id81:j_id82:j_id83:j_id105:j_id106:objects_tabs_detail:j_id124:0:j_id126:j_id127:j_id132:j_id154:0:rtpl:rtplrows:2:rt_assign
${sca_results_codescan_checkbox}                        page:console:j_id81:j_id82:j_id83:j_id105:j_id106:objects_tabs_detail:j_id124:0:j_id126:j_id127:j_id132:j_id154:0:rtpl:rtplrows:1:rt_assign
${user_story_checkbox}                                  page:console:j_id81:j_id82:j_id83:j_id105:j_id106:objects_tabs_detail:j_id124:0:j_id126:j_id127:j_id132:j_id154:0:rtpl:rtplrows:3:rt_assign
${pipelineName}                                         Main Pipeline
${projectName}                                          Main Project


*** Test Cases ***

Create Main User Credential for Sandboxes
    [Tags]                      Step3
    Appstate                    Home
    Set Test Variable           ${currentCredentialName}        0
    Set Test Variable           ${currentOrgType}               0
    Set Test Variable           ${currentUsernameExtension}     0
    Set Test Variable           ${credentialNames}              0
    Set Test Variable           ${orgTypes}                     0
    Set Test Variable           ${usernameExtensions}           0

    ${credentialNames}=         Create List                 DEV1_MAIN        DEV2_MAIN           DEV3_MAIN        DEV4_MAIN       SIT_MAIN        UAT_MAIN        HOTFIX_MAIN
    ${orgTypes}=                Create List                 Sandbox          Sandbox             Sandbox          Sandbox         Sandbox         Sandbox         Sandbox
    ${usernameExtensions}=      Create List                 .dev1            .dev2               .dev3            .dev4           .sit            .uat            .hotfix
    ${no_of_orgs}=              Get Length                  ${credentialNames}
    FOR                         ${idx}                      IN RANGE                    ${no_of_orgs}
        ${currentCredentialName}=                           Get From List               ${credentialNames}                   ${idx}
        ${currentOrgType}=      Get From List               ${orgTypes}                 ${idx}
        ${currentUsernameExtension}=                        Get From List               ${usernameExtensions}                ${idx}
        # GoTo                  ${login_url}/lightning/n/copado__Getting_Started
        LaunchApp               Getting Started
        VerifyText              Copado - leading provider of Salesforce Enterprise-class release management.
        ClickText               Credentials
        VerifyText              Credential Name             30s
        TypeText                Credential Name             ${currentCredentialName}
        DropDown                Org Type                    ${currentOrgType}
        ClickText               Create
        VerifyText              ${currentCredentialName}
        #                       Now Authenticate
        ClickText               ${currentCredentialName}
        SwitchWindow            NEW
        ClickText               Authenticate
        SwitchWindow            NEW
        TypeText                Username                    ${sf_user}${currentUsernameExtension}
        TypeSecret              Password                    ${sf_password}
        ClickText               Log In
        VerifyText              Allow
        Sleep                   1s
        ClickText               Allow
        Sleep                   15s
        VerifyText              Save                        30s
        ClickText               Save
        CloseWindow
    END
    Logout

Create Trial Users Credentials
    [Tags]                      Step3
    Appstate                    Logout
    Set Test Variable           ${currentCredentialName}    0
    Set Test Variable           ${currentOrgType}           0
    Set Test Variable           ${currentUsernameExtension}                             0
    Set Test Variable           ${credentialNames}          0
    Set Test Variable           ${orgTypes}                 0
    Set Test Variable           ${usernameExtensions}       0

    FOR                           ${uNum}                     IN RANGE                    1                ${no_of_users}+1    # Plus 1 here because the For Loop count is not inclusive.
        ${credentialNames}=       Create List                 PROD_U${uNum}               DEV1_U${uNum}    DEV2_U${uNum}       DEV3_U${uNum}    DEV4_U${uNum}               SIT_U${uNum}    UAT_U${uNum}    HOTFIX_U${uNum}
        ${orgTypes}=              Create List                 Production/Developer        Sandbox          Sandbox             Sandbox          Sandbox                     Sandbox         Sandbox         Sandbox
        ${usernameExtensions}=    Create List                 ${EMPTY}                    .dev1             .dev2              .dev3            .dev4                       .sit            .uat               .hotfix
        ${no_of_orgs}=            Get Length                  ${credentialNames}
        #                       FOR                         ${currentCredentialName}    IN               @{credentialNames}
        Login As                ${se_id}+u${uNum}+${trial_no}@copado.com                ${tu_password}
        UseModal                on
        ${internetConnectionError}=                         IsText                      Try Again
        IF                      ${internetConnectionError}
            ClickText           Try Again
        END
        UseModal                off
        FOR                     ${idx}                      IN RANGE                    ${no_of_orgs}
            ${currentCredentialName}=                       Get From List               ${credentialNames}                   ${idx}
            ${currentOrgType}=                              Get From List               ${orgTypes}      ${idx}
            ${currentUsernameExtension}=                    Get From List               ${usernameExtensions}                ${idx}
            # GoTo              ${login_url}/lightning/n/copado__Getting_Started
            LaunchApp           Getting Started
            VerifyText          Copado - leading provider of Salesforce Enterprise-class release management.
            ClickText           Credentials
            VerifyText          Credential Name             30s
            TypeText            Credential Name             ${currentCredentialName}
            DropDown            Org Type                    ${currentOrgType}
            ClickText           Create
            VerifyText          ${currentCredentialName}
            #                   Now Authenticate
            ClickText           ${currentCredentialName}
            SwitchWindow        NEW
            ClickText           Authenticate
            SwitchWindow        NEW
            TypeText            Username                    ${se_id}+u${uNum}+${trial_no}@copado.com${currentUsernameExtension}
            TypeSecret          Password                    ${tu_password}
            ClickText           Log In
            VerifyText          Allow
            Sleep               1s
            ClickText           Allow
            Sleep               15s
            ${errorMessage}=    IsText                      Unexpected character
            IF                  ${errorMessage}
                LaunchApp       Credentials
            ELSE
                VerifyText      Save                        30s
                ClickText       Save
            END
            CloseWindow
            #                   SwitchWindow                1
        END
        Logout
    END


Create API Keys 
    [Tags]               Step3
    ###### Create API key for the main user
    Appstate             Home
    GoTo                 ${login_url}/lightning/n/copado__Getting_Started
    VerifyText           Copado - leading provider of Salesforce Enterprise-class release management.
    ClickText            Account Summary
    ClickText            Create / Reset
    ClickText            API Key
    ClickItem            Create / Reset
    VerifyText           API Key Created
    GoTo                 ${login_url}/lightning/n/copado__Getting_Started
    VerifyText           Copado - leading provider of Salesforce Enterprise-class release management.
    ClickText            Account Summary
    VerifyNoText         Your user does not have an API Key.                     timeout=5s
    Logout
    ##### This section starts creating API keys for the trial users
    FOR                           ${uNum}                     IN RANGE                    1                ${no_of_users}+1    # Plus 1 here because the For Loop count is not inclusive.
        Login As                ${se_id}+u${uNum}+${trial_no}@copado.com                ${tu_password}
        UseModal                on
        ${internetConnectionError}=                         IsText                      Try Again
        IF                      ${internetConnectionError}
            ClickText           Try Again
        END
        UseModal                off
        GoTo                 ${login_url}/lightning/n/copado__Getting_Started
        VerifyText           Copado - leading provider of Salesforce Enterprise-class release management.
        ClickText            Account Summary
        ClickText            Create / Reset
        ClickText            API Key
        ClickItem            Create / Reset
        VerifyText           API Key Created
        GoTo                 ${login_url}/lightning/n/copado__Getting_Started
        VerifyText           Copado - leading provider of Salesforce Enterprise-class release management.
        ClickText            Account Summary
        VerifyNoText         Your user does not have an API Key.                     timeout=5s
        Logout
    END


    
Refesh Features Before Running Production Git Snapshot
    [Tags]              Step3
    Appstate            Home
    GoTo                ${login_url}/lightning/n/copado__Getting_Started
    ClickText           ACCOUNT SUMMARY
    ClickText           Create / Reset    
    VerifyText          Refresh features
    ClickText           Refresh features
    VerifyText          Success
    Logout


Create Production Git Snapshot
    [Tags]              Step3
    [Documentation]    Make sure you have created the .gitignore in your repo before running this.
    Appstate            Home
    GoTo                ${login_url}/lightning/o/copado__Git_Repository__c/list
    ClickText           ${git_repo}
    VerifyText          Git Repository Name
    ClickText           New Git Snapshot
    VerifyText          Save
    UseTable            xpath\=//*[@id\='thePage:theForm:pb_viewGitBackup:j_id153']/div[2]/table[1]
    TypeText            r1c1            ProductionSnapshot
    TypeText            r2c1            ${git_repo}
    TypeText            r3c1            main
    DropDown            r4c1           Allow Snapshots & Commits
    TypeText            Credential     PROD_MAIN
    ClickText           Save
    VerifyText          Take Snapshot Now        timeout=60
    ClickText           Take Snapshot Now
    ClickText           OK
    Sleep               30s
    FOR         ${i}    IN RANGE    10                                                               # Loop for 10 times
        GoTo                ${login_url}/lightning/o/copado__Git_Repository__c/list
        ClickText           ${git_repo}
        ClickText           ProductionSnapshot
        sleep                       1m                                                              # check every 30 seconds
        ${snapshotCompleted} =             IsNoText                       Warning. There are operations           5s           # look for "Hide Message" within 5 seconds
        Exit For Loop If            ${snapshotCompleted}                                              # Exit the loop when Hide Message is no longer found
    END  
    VerifyText          Complete        
    Logout                                          

Create Other Git Snapshots
    [Tags]              Step3
    Appstate            Home
#   #### Set Up Data ####
    Set Test Variable     ${currentSnapshotName}    0
    Set Test Variable     ${currentCredential}      0
    Set Test Variable     ${currentBranchName}      0

    ${allSnapshots}=         Create List            Dev1Snapshot    Dev2Snapshot    Dev3Snapshot    Dev4Snapshot    SITSnapshot    UATSnapshot    HotfixSnapshot   
    ${allCredentials}=       Create List            DEV1_MAIN       DEV2_MAIN       DEV3_MAIN       DEV4_MAIN       SIT_MAIN       UAT_MAIN       HOTFIX_MAIN
    ${allBranches}=          Create List            dev1            dev2            dev3            dev4            sit            uat            hotfix    
    ${no_of_snapshots}=      Get Length             ${allSnapshots}
#   #### Start Actions ####
    FOR                 ${idx}                      IN RANGE                    ${no_of_snapshots}  
        ${currentSnapshotName}=                     Get From List               ${allSnapshots}                   ${idx}
        ${currentCredential}=                       Get From List               ${allCredentials}                 ${idx}
        ${currentBranchName}=                       Get From List               ${allBranches}                    ${idx}
        GoTo                ${login_url}/lightning/o/copado__Git_Repository__c/list
        ClickText           ${git_repo}
        VerifyText          Git Repository Name
        ClickText           New Git Snapshot
        VerifyText          Save
        UseTable            xpath\=//*[@id\='thePage:theForm:pb_viewGitBackup:j_id153']/div[2]/table[1]
        TypeText            r1c1           ${currentSnapshotName} 
        TypeText            r2c1           ${git_repo}
        TypeText            r3c1           ${currentBranchName}
        DropDown            r4c1           Allow Commits Only
        TypeText            Credential     ${currentCredential}
        ClickText           Save
    END
    Logout



Set SCA Result Default Record Type and Layout
    [Tags]              Step3
    [Documentation]         Set up SCA record types for System Administrator profile
    Appstate                Home
    GoTo                    ${login_url}/lightning/setup/EnhancedProfiles/home
    ClickText               System Administrator
    ${welcome_message} =    IsText                      Welcome to the Enhanced Profile User Interface
    Run Keyword If          ${welcome_message}          ClickText                   No Thanks
    TypeText                page:console:pc_form:find:findComponent:input           Static Code Analysis Results
    ClickText               Static Code Analysis Results
    ClickText               Edit                        partial_match=false
    SetConfig               HandleAlerts                False
    ClickCheckbox           ${sca_results_pmd_checkbox}                             on           timeout=5
    CloseAlert              Accept
    ClickCheckbox           ${sca_results_codescan_checkbox}                        on
    ClickText               Save                        partial_match=false

Set SCA Settings Default Record Type and Layout
    [Tags]              Step3
    [Documentation]         Set up SCA record types for System Administrator profile
    Appstate                Home
    GoTo                    ${login_url}/lightning/setup/EnhancedProfiles/home
    ClickText               System Administrator
    sleep                   5s
    ${welcome_message} =    IsText                      Welcome to the Enhanced Profile User Interface
    Run Keyword If          ${welcome_message}          ClickText                   No Thanks
    TypeText                page:console:pc_form:find:findComponent:input           Static Code Analysis
    sleep                   5s
    ClickText               Static Code Analysis Settings
    ClickText               Edit                        partial_match=false
    SetConfig               HandleAlerts                False
    ClickCheckbox           ${sca_results_pmd_checkbox}                             on           timeout=5
    CloseAlert              Accept
    ClickCheckbox           ${sca_results_codescan_checkbox}                        on
    ClickText               Save                        partial_match=false

Set SCA Violations Default Record Type and Layout
    [Tags]              Step3
    [Documentation]         Set up SCA record types for System Administrator profile
    Appstate                Home
    GoTo                    ${login_url}/lightning/setup/EnhancedProfiles/home
    ClickText               System Administrator
    sleep                   5s
    ${welcome_message} =    IsText                      Welcome to the Enhanced Profile User Interface
    Run Keyword If          ${welcome_message}          ClickText                   No Thanks
    TypeText                page:console:pc_form:find:findComponent:input           Static Code Analysis
    sleep                   5s
    ClickText               Static Code Analysis Violations
    ClickText               Edit                        partial_match=false
    SetConfig               HandleAlerts                False
    ClickCheckbox           ${sca_results_pmd_checkbox}                             on           timeout=5
    CloseAlert              Accept
    ClickCheckbox           ${sca_results_codescan_checkbox}                        on
    ClickText               Save                        partial_match=false

Set User Stories Default Record Type and Layout
    [Tags]              Step3
    [Documentation]         Set up User Stories Default Record Type for System Administrator profile
    Appstate                Home
    GoTo                    ${login_url}/lightning/setup/EnhancedProfiles/home
    ClickText               System Administrator
    sleep                   5s
    ${welcome_message} =    IsText                      Welcome to the Enhanced Profile User Interface
    Run Keyword If          ${welcome_message}          ClickText                   No Thanks
    TypeText                page:console:pc_form:find:findComponent:input           User Stories
    sleep                   5s
    ClickText               User Stories                anchor=User Story Commits        partial_match=false
    ClickText               Edit                        partial_match=false
    SetConfig               HandleAlerts                False
    ClickCheckbox           ${user_story_checkbox}      on           timeout=5
    CloseAlert              Accept
    ClickText               Save                        partial_match=false

Create SCA Settings Record
    [Tags]              Step3
    [Documentation]         This creates a new PMD SCA Settings Record
    Appstate                Home
    GoTo                    ${login_url}/lightning/o/copado__Static_Code_Analysis_Settings__c/list
    ClickText               New
    TypeText                Static Code Analysis Settings Name    PMD
    ClickText               Next
    VerifyText              Save
    UseTable                xpath\=//*[@id\='thePage:theForm:pb_editSCA:pbsMain']/div[1]/table[1]
    TypeText                r1c1                        PMD SCA
    ClickText               Save
    VerifyText              Generate Default Rule Set
    ClickText               Generate Default Rule Set
    UseModal                on
    VerifyText              Generate Default Rule Set
    ClickText               Finish
    UseModal                off
    ClickText               Rules
    VerifyText              SCAR-0000


Create Pipeline
    [Tags]              Step3
    [Documentation]    Create a new pipeline named ${pipelineName}
    Appstate           Home
    GoTo               ${login_url}/lightning/o/copado__Deployment_Flow__c/list
    ClickText          New
    UseModal           on
    VerifyText         New Pipeline
    TypeText           Pipeline Name               ${pipelineName}
    TypeText           Git Repository              ${git_repo}
    ClickText          ${git_repo}                 New Git Repository
    TypeText           Main Branch                 main
    ClickCheckbox      Active                      on
    ClickText          ApexClass
    ClickText          Move selection to Chosen    Exclude From Auto Resolve
    ClickText          ApexComponent
    ClickText          Move selection to Chosen    Exclude From Auto Resolve
    ClickText          ApexPage
    ClickText          Move selection to Chosen    Exclude From Auto Resolve
    ClickText          ApexTrigger
    ClickText          Move selection to Chosen    Exclude From Auto Resolve
    TypeText           Static Code Analysis Settings                           PMD
    VerifyText         PMD SCA
    ClickText          PMD SCA
    ClickText          Save                        2
    UseModal           off
    VerifyText         ${pipelineName}

Create Project
    [Tags]              Step3
    [Documentation]    Creates a Project           in Copado
    Appstate           Home
    GoTo               ${login_url}/lightning/o/copado__Project__c/list
    VerifyText         Project Name
    ClickText          New
    UseModal           on
    VerifyText         New Project
    ClickText          Project Name
    TypeText           Complete this field.        ${projectName}
    #ClickText         Pipeline
    TypeText           Search Pipelines...         ${pipelineName}             timeout=5
    Sleep              2
    PressKey           Search Pipelines...         {ENTER}
    VerifyText         ${pipelineName}
    ClickText          ${pipelineName}
    ClickText          Save                        partial_match=false


Create Pipeline Connections
    [Tags]              Step3
    Appstate            Home
#   #### Set Up Data #####
    ${allSourceEnvs}=           Create List            UAT_MAIN       HOTFIX_MAIN     SIT_MAIN       DEV1_MAIN      DEV2_MAIN      DEV3_MAIN      DEV4_MAIN
    ${allDestinationEnvs}=      Create List            PROD_MAIN      PROD_MAIN       UAT_MAIN       SIT_MAIN       SIT_MAIN       SIT_MAIN       SIT_MAIN
    ${allBranches}=             Create List            uat            hotfix          sit            dev1           dev2           dev3           dev4
    ${no_of_envs}=              Get Length             ${allSourceEnvs}
    Set Test Variable    ${pipelineName}         Main Pipeline

    FOR                 ${idx}            IN RANGE                    ${no_of_envs}  
        ${sourceEnv}=                     Get From List               ${allSourceEnvs}                   ${idx}
        ${destEnv}=                       Get From List               ${allDestinationEnvs}              ${idx}
        ${branch}=                        Get From List               ${allBranches}                     ${idx}
        GoTo               ${login_url}/lightning/o/copado__Deployment_Flow__c/list
        ClickText          ${pipelineName}
        VerifyText         ${pipelineName}
        ClickText          Pipeline Connections
        ClickText          New
        UseModal           on
        TypeText           Source Environment        ${sourceEnv}
        ClickText          ${sourceEnv}              New Environment
        TypeText           Destination Environment    ${destEnv}
        ClickText          ${destEnv}              New Environment
        TypeText           Branch                  ${branch}
        ClickText          Save                    2
        UseModal           off
        sleep              5s                      # sometimes the View All hangs with the loading icon if we don't have a short wait here.
        ClickText          View All
        VerifyText         ${branch}
    END
    Logout


#   ###################### 
