*** Settings ***
Documentation               Locators files containing xpath locators


*** Variables ***
#${enable_dev_hub}                      /html/body/div[4]/div[1]/section/div[1]/div/div[2]/div[2]/section[1]/div/div/section/div/div[2]/div/div/div/div[2]/div/section[1]/div[1]/div[2]/label/div/div
${enable_dev_hub}                       //span[contains(.,'Enable Dev Hub')]
#${enable_source_tracking}              /html/body/div[4]/div[1]/section/div[1]/div/div[2]/div[2]/section[1]/div/div/section/div/div[2]/div/div/div/div[2]/div/section[2]/div[1]/div[2]/label/div/div
${enable_source_tracking}               //span[contains(.,'Enable Source Tracking in Developer and Developer Pro Sandboxes')]
#${enable_unlocked_packages}            /html/body/div[4]/div[1]/section/div[1]/div/div[2]/div[2]/section[1]/div/div/section/div/div[2]/div/div/div/div[2]/div/section[3]/div[1]/div[2]/label/div/div
${enable_unlocked_packages}             //span[contains(.,'Enable Unlocked Packages and Second-Generation Managed Packages')]