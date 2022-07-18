*** Settings ***

Documentation                  Set up org with one time settings needed for trials
Resource                       ./common.robot
Resource                       ./locators.robot
Suite Setup                    Setup Browser
Suite Teardown                 End suite

*** Test Cases ***


Sign In Trial Users and Change Password on Sandboxes
    [Documentation]            Sign into sandboxes to change the default passwords for all the trial users. Use this utility if the step failed during Step1 but the sandboxes were created.
    [Tags]                     Step1
    Appstate                   Home
    Logout
    @{sandboxNames}=           Create List                dev1                        dev2                 dev3                dev4    sit    uat    hotfix

    FOR                        ${uNum}                    IN RANGE                    1                    ${no_of_users}+1
        FOR                    ${currSandbox}             IN                          @{sandboxNames}
            Login To Sandbox As                           ${currSandbox}              ${se_id}+u${uNum}+${trial_no}@copado.com.${currSandbox}        ${dummy_password}
            ${changePasswordPrompt}                       isText                      Change Your Password
            IF                 ${changePasswordPrompt}
                TypeText       * Current Password         ${dummy_password}
                TypeText       New Password               ${tu_password}
                TypeText       Confirm New Password       ${tu_password}
                TypeText       Answer                     Sydney
                ClickText      Change Password
            END
            Logout
        END
    END

