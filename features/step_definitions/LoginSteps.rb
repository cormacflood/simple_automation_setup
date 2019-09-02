# frozen_string_literal: true

Given(/^I am on the Login page/) do
  $driver.navigate.to "#{TEST_HOST}"
end

Given(/^I am logged into Newswire as a Licensed Only user/) do
  if $LC_AlreadyLoggedIn == 0
    p ">>>> LC_AlreadyLoggedIn == 0 so going to the login page..."
    
    steps %(
      Given I logout
      Given I am on the Login page
    )
    $driver.navigate.to "#{TEST_HOST}"
    sleep(3)
    login_screen = LoginScreen.new($driver)
    login_screen.login(USERNAME_LC, PASSWORD_LC)
    $LC_AlreadyLoggedIn = 1
  end
end

And(/^I log in as a valid user/) do
  login_screen = LoginScreen.new($driver)
  login_screen.login(USERNAME, PASSWORD)
end

And(/^the state of the hash is/) do
  login_screen = LoginScreen.new($driver)
  login_screen.print_hash
end

And(/^I log in as a unique valid user$/) do
  
  login_screen = LoginScreen.new($driver)
  this_feature = $current_feature

  username = login_screen.get_username_for(this_feature)
  password = login_screen.get_password_for(this_feature)

  $world.puts "Current user is :"
  $world.puts username

  login_screen.login(username, password)
end

Given(/^I am logged into SYFL-API as a unique valid user$/) do

  login_screen = LoginScreen.new($driver)
  this_feature = $current_feature

  steps %(
    Given I am on the Login page
        )

       

   # sleep(1)

   if login_screen.check_hash_for(this_feature) == "NO MATCH!"
     login_screen.set_first_blank_feature_id_to(this_feature)
   end

   #sleep(1)
  login_status = login_screen.get_login_status_for(this_feature)
  p ">>>> login_status is: "
  p login_status

  if login_status == 0
    username = login_screen.get_username_for(this_feature)
    password = login_screen.get_password_for(this_feature)
  
    $world.puts "Current user is :"
    $world.puts username
  
    p ">>> executing set_login_status_for <<<<"
    login_screen.set_login_status_for(this_feature,1)

    if login_screen.login(username, password) == false
      p ">>>>> Failed to login as a unique valid user... retrying"
      homepage = FeedPage.new($driver)
      homepage.logout
      sleep(3)
      $driver.navigate.to "#{TEST_HOST}"
      sleep(10)
      login_screen.login(username, password)
    end
    this_feature = $current_feature
  end

  # Remove the cookie alert
  if $cookie_gone == false
    p ">>>> $cookie_gone == false"
    feedPage = FeedPage.new($driver)
    feedPage.remove_cookie_alert
    $cookie_gone = true
  end
  #sleep(10)
end

Given(/^'(.*)' content is enabled for '(.*)' subscription plan$/) do |permission,company|
  dc = DataCreator.new($driver)
  if dc.am_I_on_Production.nil?
    syfl_admin = SyflAdmin.new($driver)
    syfl_admin.open_company_edit_page
    login_screen = LoginScreen.new($driver)
    login_screen.login(USERNAME, PASSWORD)
    syfl_admin.search_for_company(company)
    syfl_admin.edit_company(company)
    p ">>>> result of clicking permission is..."
    p syfl_admin.click_permission(permission)
    syfl_admin.close_company_edit_page
  else
    fail
  end
end

Given(/^I am logged into Newswire as a valid user$/) do
  if $AlreadyLoggedIn == 0
    steps %(
    Given I am on the Login page
    And I log in as a valid user
        )
    $AlreadyLoggedIn = 1
  end
end

Given(/^I am logged into SYFL-API as a valid user$/) do
  if $AlreadyLoggedIn == 0
    steps %(
    Given I am on the Login page
    And I log in as a valid user
        )
    $AlreadyLoggedIn = 1
  end
end

Given(/^I logout$/) do
  p ">>>>> LOGGING OUT"
  feedPage = FeedPage.new($driver)
  $cookie_gone = false
  fail if !feedPage.logout.nil?
end