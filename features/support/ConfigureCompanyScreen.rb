# Basic model for the company configuration screen
class ConfigureCompanyScreen < BaseScreen
    # Locators for elements available on the Login Screen
    LOCATORS = {
  
        xpath: {
            currency_dropdown: "//*[contains(@aria-label, 'contract-currency-dropdown')]",
            currency_list: "//li[contains(@role, 'option')]",
            standard_rate: "//label[contains(text(),'Standard rate')]/following-sibling::input[@placeholder]",
            overages_rate: "//label[contains(text(),'Overages rate')]/following-sibling::input[@placeholder]",
        },
    }.freeze

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

    def get_currency
        currency_dropdown = wait_to_find_element(:xpath, LOCATORS[:xpath][:currency_dropdown])
        return currency_dropdown.attribute("textContent").gsub("\n", ' ').squeeze(' ')
    end

    def currency_drop_down_open
        currency_dropdown_arrow = wait_to_find_element(:xpath, LOCATORS[:xpath][:currency_dropdown])
        return currency_dropdown_arrow.attribute("aria-expanded")
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
        standard_rate.send_keys(rate)
    end

    def get_standard
        standard_rate = wait_to_find_element(:xpath, LOCATORS[:xpath][:standard_rate])
        if standard_rate.attribute("textContent").empty?
            return "0.00"
        else
            return standard_rate.attribute("textContent")
        end
    end

    def set_currency(curr)
        currency_dropdown = wait_to_find_element(:xpath, LOCATORS[:xpath][:currency_dropdown])
        click_on(currency_dropdown)
        currency_list = wait_to_find_element(:xpath, LOCATORS[:xpath][:currency_list])
        currency_list.each do |a|
            p "Menu item to check is: "
            p a.text
            if item == a.text
              p "Menu item found:"
              p a.text
              click_on(a)
            end
          end
          $world.puts "\n\n >>> #{item} <<< not found in list" 
    end
  
    def set_overages(rate)
        overages_rate = wait_to_find_element(:xpath, LOCATORS[:xpath][:overages_rate])
        click_on(overages_rate)
        overages_rate.send_keys(rate)
    end

    def get_overages
        overages_rate = wait_to_find_element(:xpath, LOCATORS[:xpath][:overages_rate])
        if overages_rate.attribute("textContent").empty?
            return "0.00"
        else
            return overages_rate.attribute("textContent")
        end
    end

end