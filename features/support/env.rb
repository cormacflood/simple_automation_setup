# frozen_string_literal: true

require "rubygems"
require "selenium-cucumber"

#Environments - unable to pass in another value from the command line, so this is used for now
TEST_HOST = "https://syfl-api-dev.storyful.com"

#Logins
USERNAME = (ENV['USERNAME'] || "cormac.flood@storyful.com")
PASSWORD = (ENV['PASSWORD'] || "Dublin3890!")

#Don't login if already logged in
$AlreadyLoggedIn = 0