# frozen_string_literal: true

Given(/^I open the new company page/) do
    $driver.navigate.to "#{TEST_HOST}/companies/new"
end

Given(/^the currency, standard rate and overages fields appear with the following labels and default text:/) do |table|
    config_company = ConfigureCompanyScreen.new($driver)
    data = table.raw
    data.each do |rowdata|
     #   fail if !config_company.check_values(rowdata[0],rowdata[1])
     p ">>>> THE FOLLOWING ITEM: "
     p rowdata[0]
     p ">>>> SHOULD HAVE A VALUE OF: "
     p rowdata[1]
     p ">>>> AND THE RESULT IS: "
     p config_company.check_values(rowdata[0],rowdata[1])
    end
end

Given(/^only the following 5 currencies are listed for Contract Currency:/) do |table|
    config_company = ConfigureCompanyScreen.new($driver)
    data = table.raw
    data.each do |rowdata|
        fail if config_company.check_currency_list_contains(rowdata[0]).nil?
    end
end