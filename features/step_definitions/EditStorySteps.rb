# frozen_string_literal: true

Given(/^I open story '(.*)'/) do |story_id|
    $driver.navigate.to "#{TEST_HOST}/stories/#{story_id}"
end

Given(/^slider:(.*) is set to (.*)/) do |slider,status|
  edit_story = StoryDetails.new($driver)
  fail if !edit_story.update_slider(slider,status).nil?
end

Given(/^I set (.*) to (.*)/) do |dropdown,value|
  edit_story = StoryDetails.new($driver)
  fail if !edit_story.update_dropdown(dropdown,value).nil?
end

Given(/^I click on the (.*) tab/) do |tab_name|
  edit_story = StoryDetails.new($driver)
  fail if !edit_story.click_tab(tab_name).nil?
end

Given(/^I enter free text '(.*)' for (.*)/) do |value,text_field|
  edit_story = StoryDetails.new($driver)
  fail if !edit_story.enter_text(text_field,value).nil?
end

Given(/^I enter and choose free text '(.*)' for (.*)/) do |value,text_field|
  edit_story = StoryDetails.new($driver)
  fail if !edit_story.enter_text_and_choose(text_field,value).nil?
end

Given(/^I click button:Add Story Item/) do
  edit_story = StoryDetails.new($driver)
  fail if !edit_story.click_add_story_item.nil?
end

Given(/^I expand section (.*)/) do |section|
  edit_story = StoryDetails.new($driver)
  fail if !edit_story.expand_section(section).nil?
end

Given(/^the '(.*)' free text field contains '(.*)'/) do |text_area,text_to_check|
  edit_story = StoryDetails.new($driver)
  fail if !edit_story.check_text(text_area,text_to_check).nil?
end

Given(/^I drag an item from position (.*) to position (.*)/) do |from_pos,to_pos|
  edit_story = StoryDetails.new($driver)
  fail if !edit_story.reorder_items(from_pos,to_pos).nil?
end

Given(/^I click on story item toolbar (.*)/) do |toolbar_number|
  edit_story = StoryDetails.new($driver)
  fail if !edit_story.select_story_items_toolbar(toolbar_number).nil?
end

Given(/^I click on the (.*) toolbar button/) do |toolbar_button|
  edit_story = StoryDetails.new($driver)
  fail if !edit_story.click_toolbar_button(toolbar_button).nil?
end

Given(/^I select MetaData Channel:(.*)/) do |channel|
  edit_story = StoryDetails.new($driver)
  fail if !edit_story.select_meta_channel(channel).nil?
end

Given(/^I select MetaData Category:(.*)/) do |category|
  edit_story = StoryDetails.new($driver)
  fail if !edit_story.select_meta_category(category).nil?
end