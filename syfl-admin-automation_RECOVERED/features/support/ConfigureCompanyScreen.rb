# Basic model for the company configuration screen
class ConfigureCompanyScreen < BaseScreen
    # Locators for elements available on the Login Screen
    LOCATORS = {
  
        xpath: {
            # Currency shit
            currency_dropdown: "//*[contains(@aria-label, 'contract-currency-dropdown')]",
            currency_list: "//li[contains(@role, 'option')]",
            standard_rate: "//label[contains(text(),'Standard rate')]/following-sibling::input[@placeholder]",
            overages_rate: "//label[contains(text(),'Overages rate')]/following-sibling::input[@placeholder]",
            save_button: "//div/button[contains(@class, 'success')]",
            validation_error: "input:invalid",
            # Bundle shit
            
            trial: "//*[contains(text(),'Trial')]/../input[contains(@class,'custom-checkbox')]",
            auto_renew: "//*[contains(text(),'Auto renew')]/../input[contains(@class,'custom-checkbox')]",

            download_start: "//label[contains(text(),' Download Period Starts*:')]/../div/div/input[contains(@class,'ember-text-field')]",
            access_expiration: "//label[contains(text(),' Access expiration date*:')]/../div/div/input[contains(@class,'ember-text-field')]",

            lc_off: "//input[@value='off']",
            lc_off_control: "//*[contains(text(),'Off')]",

            lc_payg: "//input[@value='payg']",
            lc_payg_control: "//*[contains(text(),'PAYG')]",

            lc_licensed_bundle: "//input[@value='bundle']",
            lc_licensed_bundle_control: "//*[contains(text(),'Licensed Bundle')]",

            bundle_size: "//label[contains(text(),'Bundle size*')]/following-sibling::*[contains(@class,'input')]",
            bundle_resets_dropdown: "//label[contains(text(),'Bundle resets*')]/following-sibling::div[contains(@aria-expanded,'true')]",
            bundle_resets_dropdown_arrow: "//label[contains(text(),'Bundle resets*')]/following-sibling::div/span[contains(@class,'ember-power-select-status-icon')]",
            bundle_resets_options: "//li[contains(@role,'option')]",

            licensed_only: "//*[contains(text(),'Licensed Only')]/../input[contains(@class,'custom-checkbox')]",
        },
        css: {
            validation_error: "input:invalid"
        }
    }.freeze

    def get_allow_licensed_downloads_state
        lc_off = wait_to_find_element(:xpath, LOCATORS[:xpath][:lc_off])

        #lc_off_control = wait_to_find_element(:xpath, LOCATORS[:xpath][:lc_off_control])

        #click_on(lc_off_control)

        lc_payg = wait_to_find_element(:xpath, LOCATORS[:xpath][:lc_payg])

        #lc_payg_control = wait_to_find_element(:xpath, LOCATORS[:xpath][:lc_payg_control])

        #click_on(lc_payg_control)

        lc_licensed_bundle = wait_to_find_element(:xpath, LOCATORS[:xpath][:lc_licensed_bundle])

        #lc_licensed_bundle_control = wait_to_find_element(:xpath, LOCATORS[:xpath][:lc_licensed_bundle_control])

        #click_on(lc_licensed_bundle_control)

        # if !lc_off.checked
        #     p "OFF IS NOT CHECKED!!"
        # else
        #     p "OFF IS CHECKED!!"
        # end

        # if !lc_payg.checked
        #     p "PAYG IS NOT CHECKED!!"
        # else
        #     p "PAYG IS CHECKED!!"
        # end

        # if !lc_licensed_bundle.checked
        #     p "LICENSED BUNDLE IS NOT CHECKED!!"
        # else
        #     p "LICENSED BUNDLE IS CHECKED!!"
        # end

        if lc_off.checked
            return 'Off'
        end

        if lc_payg.checked
            return 'PAYG'
        end

        if lc_licensed_bundle.checked
            return 'Licensed Bundle'
        end

        p 'Unable to read Allow Licensed Bundles Download state'
        return 'Unable to read Allow Licensed Bundles Download state'

    end

    def set_allow_licensed_downloads(state)
        case state
        when "Off"
            lc_off_control = wait_to_find_element(:xpath, LOCATORS[:xpath][:lc_off_control])
            return click_on(lc_off_control)
        when "PAYG"
            lc_payg_control = wait_to_find_element(:xpath, LOCATORS[:xpath][:lc_payg_control])
            return click_on(lc_payg_control)
        when "Licensed Bundle"
            lc_licensed_bundle_control = wait_to_find_element(:xpath, LOCATORS[:xpath][:lc_licensed_bundle_control])
            return click_on(lc_licensed_bundle_control)
        end
        return false
    end

    def set_bundle_size(amount)
        bundle_size = wait_to_find_element(:xpath, LOCATORS[:xpath][:bundle_size])
        click_on(bundle_size)
        sleep(1)
        for i in 1..(bundle_size.value.length) do
            bundle_size.send_keys(:backspace);
        end
        sleep(1)
        bundle_size.send_keys(amount)
    end

    def set_download_start(start_date)
        download_start = wait_to_find_element(:xpath, LOCATORS[:xpath][:download_start])
        click_on(download_start)
        sleep(1)
        for i in 1..(download_start.value.length) do
            download_start.send_keys(:backspace);
        end
        sleep(1)
        download_start.send_keys(start_date)
        download_start.send_keys(:return)
    end

    def set_bundle_reset(reset_date)
        reset_dropdown = wait_to_find_element(:xpath, LOCATORS[:xpath][:bundle_resets_dropdown])
        if reset_dropdown.nil?
            bundle_resets_dropdown_arrow = wait_to_find_element(:xpath, LOCATORS[:xpath][:bundle_resets_dropdown_arrow])
            click_on(bundle_resets_dropdown_arrow)
            sleep(1)
        end
        bundle_resets_options = wait_to_find_elements(:xpath, LOCATORS[:xpath][:bundle_resets_options])
        p "bundle_resets_options list size is: "
        p bundle_resets_options.size
        p bundle_resets_options
        bundle_resets_options.each do |a|
            p a.text
            if a.text.include? reset_date
                return click_on(a)
            end
        end
        return false     
    end

    def set_access_expiration(date)
        access_expiration = wait_to_find_element(:xpath, LOCATORS[:xpath][:access_expiration])
        click_on(access_expiration)
        sleep(1)
        for i in 1..(access_expiration.value.length) do
            access_expiration.send_keys(:backspace)
        end
        sleep(1)
        access_expiration.send_keys(date)
        access_expiration.send_keys(:return)
    end

    def get_auto_renew_state
        auto_renew = wait_to_find_element(:xpath, LOCATORS[:xpath][:auto_renew])
        p "auto_renew.checked is"
        if auto_renew.checked
            return "ON"
        else
            return "OFF"
        end
    end

    def set_auto_renew(state)
        auto_renew = wait_to_find_element(:xpath, LOCATORS[:xpath][:auto_renew])
        p "get_auto_renew_state is: "
        p get_auto_renew_state
        if get_auto_renew_state != state
            click_on(auto_renew)
        end
    end

    def get_trial_state
        trial = wait_to_find_element(:xpath, LOCATORS[:xpath][:trial])
        p "trial.checked is"
        if trial.checked
            return "ON"
        else
            return "OFF"
        end
    end

    def set_trial(state)
        trial = wait_to_find_element(:xpath, LOCATORS[:xpath][:trial])
        if get_trial_state != state
            click_on(trial)
        end
    end

    def get_licensed_only_state
        licensed_only = wait_to_find_element(:xpath, LOCATORS[:xpath][:licensed_only])
        p "licensed_only.checked is"
        licensed_only.checked
        if licensed_only.checked
            return "ON"
        else
            return "OFF"
        end
    end

    def set_licensed_only(state)
        licensed_only = wait_to_find_element(:xpath, LOCATORS[:xpath][:licensed_only])
        if get_licensed_only_state != state
            click_on(licensed_only)
        end
    end

    def check_validation_error_contains(message)
        validation_error = wait_to_find_element(:css, LOCATORS[:css][:validation_error])
        p validation_error.attribute("validationMessage")
        return validation_error.attribute("validationMessage").include? message
    end

    def check_validation_error_exists
        validation_error = wait_to_find_element(:css, LOCATORS[:css][:validation_error])
        return validation_error
    end

    def click_save
        save = wait_to_find_elements(:xpath, LOCATORS[:xpath][:save_button])
        click_on(save[0])
    end

    def check_values(val_to_check,expected_result)
        case val_to_check
        when "Contract Currency"
            return get_currency.include? expected_result
        when "Standard Rate"
            return get_standard.include? expected_result
        when "Overages Rate"
            return get_overages.include? expected_result
        end
    end

    def set_values(item,value)
        case item
        when "Contract Currency"
            return set_currency(value)
        when "Standard Rate"
            return set_standard(value)
        when "Overages Rate"
            return set_overages(value)
        end
    end

    def get_currency
        currency_dropdown = wait_to_find_element(:xpath, LOCATORS[:xpath][:currency_dropdown])
        return currency_dropdown.attribute("textContent").gsub("\n", ' ').squeeze(' ')
    end

    def currency_drop_down_open
        sleep(1)
        currency_dropdown_arrow = wait_to_find_element(:xpath, LOCATORS[:xpath][:currency_dropdown])
        return currency_dropdown_arrow.attribute("aria-expanded")
    end

    def click_currency_drop_down
        currency_dropdown_arrow = wait_to_find_element(:xpath, LOCATORS[:xpath][:currency_dropdown])
        click_on(currency_dropdown_arrow)
    end
    
    def check_currency_list_contains(currency)
        if !currency_drop_down_open
             currency_dropdown_arrow = wait_to_find_element(:xpath, LOCATORS[:xpath][:currency_dropdown])
            click_on(currency_dropdown_arrow)
        end
        currency_dropdown = wait_to_find_elements(:xpath, LOCATORS[:xpath][:currency_list])
        p "Looking for #{currency} in list"
        currency_dropdown.each do |a|
            p "Currency item to check against is: "
            p a.text
            if a.text.include? currency
              p "Currency item found:"
              p a.text
              #click_on(currency_dropdown_arrow)
              return a.text
            end
        end
        p "Failed to find #{currency} in list"
        $world.puts "Failed to find #{currency} in list"
        return nil
    end

    def get_currency_list_size
        currency_dropdown = wait_to_find_elements(:xpath, LOCATORS[:xpath][:currency_list])
        return currency_dropdown.size
    end

    def set_standard(rate)
        standard_rate = wait_to_find_element(:xpath, LOCATORS[:xpath][:standard_rate])
        click_on(standard_rate)
        standard_rate.clear
        standard_rate.send_keys(rate)
    end

    def get_standard
        standard_rate = wait_to_find_element(:xpath, LOCATORS[:xpath][:standard_rate])
        p "standard_rate element is :"
        p standard_rate.value
        if standard_rate.value == ""
            return "0.00"
        else
            return standard_rate.value
        end
    end

    def set_currency(curr)
        if !currency_drop_down_open
            currency_dropdown_arrow = wait_to_find_element(:xpath, LOCATORS[:xpath][:currency_dropdown])
           click_on(currency_dropdown_arrow)
       end
       sleep(2)
        currency_list = wait_to_find_elements(:xpath, LOCATORS[:xpath][:currency_list])
        currency_list.each do |a|
            p "Menu item to check is: "
            p a.text
            if a.text.include? curr
              p "Menu item found:"
              p a.text
              return click_on(a)
            end
          end
          $world.puts "\n\n >>> #{curr} <<< not found in list" 
    end
  
    def set_overages(rate)
        overages_rate = wait_to_find_element(:xpath, LOCATORS[:xpath][:overages_rate])
        click_on(overages_rate)
        overages_rate.clear
        overages_rate.send_keys(rate)
    end

    def get_overages
        overages_rate = wait_to_find_element(:xpath, LOCATORS[:xpath][:overages_rate])
        p "overages_rate element is :"
        p overages_rate.value
        if overages_rate.value == ""
            return "0.00"
        else
            return overages_rate.value
        end
    end

end