# frozen_string_literal: true

# Off PAYG 'Licensed Bundle'
Given(/^I have Allow Licensed Downloads = '(.*)'/) do |state|
    config_company = ConfigureCompanyScreen.new($driver)
    fail if !config_company.set_allow_licensed_downloads(state).nil?
end

Then(/^Allow Licensed Downloads is '(.*)'/) do |state|
    config_company = ConfigureCompanyScreen.new($driver)
    fail if config_company.get_allow_licensed_downloads_state != state
end

# 1000
Given(/^I have a bundle size = '(.*)'/) do |bundle_size|
    config_company = ConfigureCompanyScreen.new($driver)
    fail if !config_company.set_bundle_size(bundle_size).nil?
end

# 31 Nov 2019
Given(/^Download Period Starts = '(.*)'/) do |start_date|
    config_company = ConfigureCompanyScreen.new($driver)
    fail if !config_company.set_download_start(start_date).nil?
end

# 3 Monthly (on calendar date)
Given(/^Bundle resets = '(.*)'/) do |reset_date|
    config_company = ConfigureCompanyScreen.new($driver)
    fail if !config_company.set_bundle_reset(reset_date).nil?
end

# Access Expiration Date
Given(/^I set Access Expiration Date = '(.*)'/) do |expiry|
    config_company = ConfigureCompanyScreen.new($driver)
    fail if !config_company.set_access_expiration(expiry).nil?
end

# Auto-renew
Given(/^I set Auto renew = '(.*)'/) do |state|
    config_company = ConfigureCompanyScreen.new($driver)
    fail if !config_company.set_auto_renew(state).nil?
    sleep(1)
end

# Trial
Given(/^I set Trial = '(.*)'/) do |state|
    config_company = ConfigureCompanyScreen.new($driver)
    fail if !config_company.set_trial(state).nil?
end

# Licensed Only
Given(/^I set Licensed Only = '(.*)'/) do |state|
    config_company = ConfigureCompanyScreen.new($driver)
    fail if !config_company.set_licensed_only(state).nil?
end

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
    dc = DataCreator.new($driver)
    if dc.am_I_on_Production.nil?
        config_company = ConfigureCompanyScreen.new($driver)
        fail if !config_company.click_save.nil?
    else
        p "Unable to save to Production"
    end
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
