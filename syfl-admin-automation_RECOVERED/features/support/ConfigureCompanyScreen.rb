# Basic model for the company configuration screen
class ConfigureCompanyScreen < BaseScreen
    # Locators for elements available on the Login Screen
    LOCATORS = {
  
        xpath: {
            currency_dropdown: "//*[contains(@aria-label, 'contract-currency-dropdown')]",
            currency_list: "//li[contains(@role, 'option')]",
            standard_rate: "//label[contains(text(),'Standard rate')]/following-sibling::input[@placeholder]",
            overages_rate: "//label[contains(text(),'Overages rate')]/following-sibling::input[@placeholder]",
            save_button: "//div/button[contains(@class, 'success')]",
            validation_error: "input:invalid",
        },
        css: {
            validation_error: "input:invalid"
        }
    }.freeze

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