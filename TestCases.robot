*** Settings ***
Library           SeleniumLibrary

Resource         Keyword.robot
Resource         Variablefile.robot

Test Setup       Test_setup
Test Teardown    Test_teardown
*** Test Cases ***

Scenario_1_Successfull_Login
        Login_to_Portal         ${user_1}       ${password}
        sleep   2
        Logout_from_Portal

Scenario_2_Failed_Login
        Login_to_Portal         ${user_2}       ${password}

Scenario_3_Order_a_Product
        Login_to_Portal         ${user_1}       ${password}
        sleep   2
        Select From List By Label       xpath=//*[@id="header_container"]/div[2]/div/span/select      Price (low to high)
        sleep   2
        Purchase_Item
        Sleep   2
        Logout_from_Portal
