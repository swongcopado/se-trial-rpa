*** Settings ***

Documentation                  Set up org with one time settings needed for trials
Resource                       ./common.robot
Resource                       ./locators.robot
Suite Setup                    Setup Browser
Suite Teardown                 End suite

*** Test Cases ***

Setup Org for Trial
    # Turn off the password checks
    [Tags]                     Step1
    Appstate                   Home
    Log                        Turning off default password checks...    console=true
    GoTo                       ${login_url}/lightning/setup/SecurityPolicies/home
    VerifyText                 User passwords expire in
    DropDown                   User passwords expire in    0
    DropDown                   Enforce password history    0
    ClickItem                  Save
    Log                        Password checks have been turned off    console=true

    Sleep                      10s

    # Set Login Access Policies
    Log                        Setting Login Access Policies...        console=true
    GoTo                       ${login_url}/lightning/setup/LoginAccessPolicies/home
    VerifyText                 Manage Support Options
    ClickCheckbox              Administrators Can Log in as Any User                   on
    ClickText                  Save
    VerifyText                 Changes Saved
    Log                        Login Access Policies are set. Administrators can now log in as any user    console=true

    Sleep                      10s

    # Enable Dev Hub
    Log                        Enabling Dev Hub, Source Tracking and Unlocked Packages...                  console=true
    GoTo                       ${login_url}/lightning/setup/DevHub/home
    ClickElement                ${enable_dev_hub}
    ClickElement                ${enable_source_tracking}
    ClickElement                ${enable_unlocked_packages}
    Log                        Dev Hub, Source Tracking and Unlocked Packages have been enabled            console=true

    Sleep                      10s

    #Enable Enhanced User Profile Settings
    Log                        Enabling Enhanced User Profile Settings...                        console=true
    GoTo                       ${login_url}/lightning/setup/UserManagementSettings/home
    #ClickElement              /html/body/div[4]/div[1]/section/div[1]/div/div[2]/div[2]/section[1]/div/div/section/div/div[2]/div/div/div/div[2]/article[2]/div/div/div[2]/div/input
    ClickElement                //*[@id\='newProfileUi']    timeout=10
    Log                        Enhanced User Profile Settings enabled.                        console=true

    # Enable Login IP Ranges
    Log                        Enabling Login IP Ranges...                        console=true
    GoTo                       ${login_url}/lightning/setup/EnhancedProfiles/home
    ClickText                  System Administrator
    UseModal                   on
    ${enhProfilePrompt}        isText                      Welcome to the Enhanced Profile User Interface
    IF                         ${enhProfilePrompt}
        ClickText              No Thanks
    END
    UseModal                   off
    ClickText                  Login IP Ranges
    ClickText                  Add                         delay=5s
    TypeText                   IP Start Address            0.0.0.0
    TypeText                   IP End Address              255.255.255.255
    ClickText                  Save
    Log                        Login IP Ranges Enabled from 0.0.0.0 to 255.255.255.255       console=true

    Logout

Create Trial Users
    [Documentation]            Automates the creation of trial users. Make sure no_of_users variable is set.
    [Tags]                     Step1
    Appstate                   Home
    FOR                        ${currentUserNo}            IN RANGE                    1                          ${no_of_users}+1
        GoTo                   ${login_url}/lightning/setup/ManageUsers/home
        VerifyText             All Users
        ClickItem              New User
        TypeText               First Name                  Trial User
        TypeText               Last Name                   ${currentUserNo}
        TypeText               Email                       ${se_id}@copado.com
        TypeText               Username                    ${se_id}+u${currentUserNo}+${trial_no}@copado.com      clear_key={CONTROL + a}
        Dropdown               User License                Salesforce
        Dropdown               Profile                     System Administrator
        ClickCheckbox          Flow User                   on
        #                      ClickCheckbox               Generate new password and notify user immediately      off
        ClickItem              Save
    END
    Logout

Set Default Trial User Passwords                       
    [Documentation]            Make sure the Apex class to set default user password has been created in the Salesforce org
    [Tags]                     Step1
    Appstate                   Home
    ClickText                  Setup
    ClickText                  Developer Console
    SwitchWindow               2
    ClickText                  Debug
    ClickText                  Open Execute Anonymous Window
    TypeText                   Enter Apex Code             CopadoTrialUtilities.setTrialUserPasswords('%${se_id}+u%', '${dummy_password}');
    ClickText                  Execute
    VerifyText                 Success                     anchor=Status
    CloseWindow
    Logout

Sign In Trial Users and Change Password
    [Documentation]            After setting the passwords, sign in the users
    [Tags]                     Step1
    Appstate                   Home
    Logout
    FOR                        ${uNum}                     IN RANGE                    1                          ${no_of_users}+1
        Login As               ${se_id}+u${uNum}+${trial_no}@copado.com                ${dummy_password}
        ${changePasswordPrompt}                            isText                      Change Your Password
        IF                     ${changePasswordPrompt}
            TypeText           * Current Password          ${dummy_password}
            TypeText           New Password                ${tu_password}
            TypeText           Confirm New Password        ${tu_password}
            TypeText           Answer                      Sydney
            ClickText          Change Password
        END
        Logout
    END


Create Sandboxes
    [Documentation]            Automates the creation of Sandboxes.
    [Tags]                     Step1
    Appstate                   Home

    #### Set Up Data ####
    @{SB}=                     Create List                 Dev1                        Dev2                       Dev3                Dev4    SIT     UAT    Hotfix
    #####################

    FOR                        ${currentSandboxName}       IN                          @{SB}
        Log                    Creating Sandbox ${currentSandboxName}...               console=true
        GoTo                   ${login_url}/lightning/setup/DataManagementCreateTestInstance/home
        VerifyText             Available Sandbox Licenses
        ClickItem              New Sandbox
        VerifyText             Sandbox Information
        TypeText               Name                        ${currentSandboxName}
        DropDown               Create From                 Production
        ClickItem              Next                        Developer                   partial_match=false
        VerifyText             Apex Class
        ClickText              Create
        Log                    Sandbox ${currentSandboxName} creation started.         console=true
    END
    Logout