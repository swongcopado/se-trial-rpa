*** Settings ***

Documentation              Install Copado Deployer and Copado Trial managed packages
Resource                   ./common.robot
Suite Setup                Setup Browser
Suite Teardown             End suite


*** Test Cases ***
Install Copado Deployer
    [Tags]                Step2
    Appstate              Home
    Set Local Variable    ${package_url}              ${login_url}/packaging/installPackage.apexp?p0=${package_id}
    GoTo                  ${package_url}
    VerifyText            Install Copado Deployer
    ClickText             Install for Admins Only
    ClickText             Install                         timeout=120s
    ClickCheckbox         on                          on
    ClickText             Continue
    FOR                   ${i}                        IN RANGE                    50                        # Loop for 10 times
        GoTo              ${login_url}lightning/setup/ImportedPackage/home        # Load the Installed Packages screen.
        ${isFound} =      IsText                      Copado BasePackage          10s                       # Check that Copado has been installed.
        Exit For Loop If                              ${isFound}                  # Exit loop if found
        Sleep             1m                          # Otherwise, check again in 1 minutes
    END
    VerifyText            Copado BasePackage

Install Copado Trial Package
    [Tags]                Step2
    Appstate              Home
    Set Local Variable    ${package_url}              ${login_url}/packaging/installPackage.apexp?p0=04t1U000007sjPJ
    GoTo                  ${package_url}
    VerifyText            Install Copado Trial
    ClickText             Install for Admins Only
    ClickText             Install                         timeout=120s
#    ClickCheckbox         on                          on
#    ClickText             Continue
    FOR                   ${x}                        IN RANGE                    20                      # Loop for 10 times
        GoTo              ${login_url}lightning/setup/ImportedPackage/home                                # Load the Installed Packages screen.
        ${isFound} =      IsText                      Copado Trial                10s                     # Check that Copado has been installed.
        Exit For Loop If                              ${isFound}                                          # Exit loop if found
        Sleep             1m                          # Otherwise, check again in 5 minutes
    END
    VerifyText            Copado Trial

Enable Copado Support Login
    [Tags]                Step2
    [Documentation]       Turns on access for Copado Support
    Appstate              Home
    ClickText             View profile
    ClickText             Settings
    VerifyText            First Name
    ClickText             Grant Account Login Access
    Sleep                 3s
    DropDown              Copado Solutions SL Support                             [[4]]                     #select the 5th option
    ClickText             Save



