# frozen_string_literal: true

Given(/^I open the new company page/) do
    $driver.navigate.to "#{TEST_HOST}/companies/new"
    sleep(3)
end

Given(/^the currency, standard rate and overages fields appear with the following labels and default text:/) do |table|
    config_company = ConfigureCompanyScreen.new($driver)
    data = table.raw
    data.each do |rowdata|
     p ">>>> THE FOLLOWING ITEM: "
     p rowdata[0]
     p ">>>> SHOULD HAVE A VALUE OF: "
     p rowdata[1]
     p ">>>> AND THE RESULT IS: "
     p config_company.check_values(rowdata[0],rowdata[1])
    fail if !config_company.check_values(rowdata[0],rowdata[1])
    end
end

Given(/^only the following 5 currencies are listed for Contract Currency:/) do |table|
    config_company = ConfigureCompanyScreen.new($driver)
    data = table.raw
    data.each do |rowdata|
        p "Checking... "
        p config_company.check_currency_list_contains(rowdata[0])
        p "------------"
        fail if config_company.check_currency_list_contains(rowdata[0]).nil?
    end
    if config_company.currency_drop_down_open
        config_company.click_currency_drop_down
    end
end

Given(/^I edit a company '(.*)'/) do |company|
    $driver.navigate.to "#{TEST_HOST}/companies/#{company}/edit"
end

Given(/^I configure the following rates values/) do |table|
    config_company = ConfigureCompanyScreen.new($driver)
    data = table.raw
    data.each do |rowdata|
        fail if !config_company.set_values(rowdata[0],rowdata[1]).nil?
    end
end

Given(/^I click Save/) do
    config_company = ConfigureCompanyScreen.new($driver)
    fail if !config_company.click_save.nil?
    #sleep(10)
end

Given(/^a validation error appears containing text '(.*)'/) do |message|
    config_company = ConfigureCompanyScreen.new($driver)
    fail if !config_company.check_validation_error_contains(message)
end

Given(/^I do not see a validation error/) do
    config_company = ConfigureCompanyScreen.new($driver)
    fail if !config_company.check_validation_error_exists.nil?
end

# Given(/^a validation error appears/) do
#     config_company = ConfigureCompanyScreen.new($driver)
#     fail if config_company.check_validation_error_exists.nil?
# end
