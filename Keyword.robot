*** Keywords ***
Test_setup
    OPEN BROWSER            ${LOGIN URL}        chrome
    Maximize Browser Window
    ${Pgtitle}=             Get Title
    Log                     ${Pgtitle}          WARN

#Test_setup
#        ${c_opts} =             Evaluate        sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
#        Call Method             ${c_opts}       add_argument    headless
#        Call Method             ${c_opts}       add_argument    disable-gpu
#        Call Method             ${c_opts}       add_argument    no-sandbox
#        Call Method             ${c_opts}       add_argument    window-size\=1420,1080
#        Create Webdriver        Chrome          crm_alias       chrome_options=${c_opts}

Test_teardown
        Close All Browsers

Login_to_Portal
        [Arguments]                     ${Username}         ${Password}

        Set Selenium Timeout            5s
        wait until page contains        Swag Labs
        wait until page contains element    id=user-name

        Input Text                      id=user-name             ${Username}
        Sleep   1
        Input Text                      id=password              ${Password}
        Sleep   1
        click button                    Login
        TRY
            wait until page contains        Products
            ${Pgtitle}=  Get Title
            Should be equal as strings      ${Pgtitle}          Swag Labs

            ${PgUrl}=  Get Location
            Should be equal as strings      ${PgUrl}            https://www.saucedemo.com/inventory.html
        EXCEPT
            ${errorMsg}=   Get Text         //*[@id="login_button_container"]/div/form/div[3]/h3
            Should Contain                  ${errorMsg}         Sorry, this user has been locked out.
        END

Logout_from_Portal
        click button                        id=react-burger-menu-btn
        wait until page contains            Logout
        sleep       2
        click link                          Logout
        Sleep   1
        wait until page contains element    id=user-name
        ${PgUrl}=  Get Location
        Should be equal as strings          ${PgUrl}          https://www.saucedemo.com/

Purchase_Item
        ${itemName}=        Get Text        xpath=//*[@id="item_2_title_link"]/div
        ${itemPrice}=       Get Text        xpath=//*[@id="inventory_container"]/div/div[1]/div[2]/div[2]/div
        click button        xpath=/html/body/div/div/div/div[2]/div/div/div/div[1]/div[2]/div[2]/button
        Sleep   1
        Wait Until Element Contains         xpath=/html/body/div/div/div/div[2]/div/div/div/div[1]/div[2]/div[2]/button         Remove
        Click Link          xpath=//*[@id="shopping_cart_container"]/a
        Sleep   1
        Wait Until Page Contains            Your Cart
        Wait Until Page Contains            ${itemName}
        Click Button        Checkout
        Sleep   1
        Wait Until Page Contains            Checkout: Your Information

        Input Text          id=first-name       ${user_firstname}
        Input Text          id=last-name        ${user_lastname}
        Input Text          id=postal-code      ${zip_code}

        Click Button        Continue
        Sleep   1

        Wait Until Page Contains                Checkout: Overview
        Page Should Contain                     ${itemName}
        Page Should Contain                     ${itemPrice}
        Element should contain                  xpath=//*[@id="checkout_summary_container"]/div/div[2]/div[8]       Total: $8.63

        Click Button        Finish
        Sleep   1

        Page Should Contain                     Thank you for your order!
        Page Should Contain                     Your order has been dispatched, and will arrive just as fast as the pony can get there!

        Click Button        Back Home
        Sleep   1
