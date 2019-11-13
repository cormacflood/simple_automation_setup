Feature: SYFL-API - Edit Story

  Background:
    Given I am logged into SYFL-API as a valid user

@all @edit_story_1
Scenario: Edit a story
Given I open story '227467'
#lead image
And slider:LEAD IMAGE is set to ON
And slider:LEAD IMAGE is set to OFF
#push to top
And slider:PUSH TO TOP is set to ON
And slider:PUSH TO TOP is set to OFF
#story template
And I set STORY TEMPLATE to LONG FORM
And I set STORY TEMPLATE to STANDARD
#editorial agenda
And I set EDITORIAL AGENDA to AUTOTEST2
And I set EDITORIAL AGENDA to AUTOTEST1 - This is a card with a link
#clearance, guidance, redistribution
And I click on the Clearance tab
And I set Clearance to EMBED
And I click on the Guidance tab
And I set Guidance to GRAPHIC
And I click on the Redistribution tab
And I set Redistribution to NO
#source
And I enter free text 'DOGS TRUST' for Stated Source
And I set SOURCE to CHECKING
#location
And I enter free text 'Dublin, Ireland' for Stated Location
And I enter free text '10,20' for Lat, Lng
And I enter free text '90' for Zoom Level
#curator
And I enter free text 'Cormac Flood' for Select a curator
And I set LOCATION to CHECKING
#date
And I enter free text 'January 13 2010' for Stated Date
And I set DATE to CHECKING

@all @edit_story_1 @edit_story_3
Scenario: Edit a story - CONTENT
Given I click on story item toolbar 1
And I click on the Editorial toolbar button
When I enter free text 'Updating Editorial Content, yo' for Enter your editorial content here
And I click button:Add Story Item
And I expand section 2
Then the 'Editorial content' free text field contains 'Updating Editorial Content, yo'

@all @edit_story_1 @edit_story_2
Scenario: Edit a story - META DATA
#temp
Given I open story '226259'
And I select MetaData Channel:Licensed
And I select MetaData Category:animals
And I select MetaData Category:funny
And I enter and choose free text 'Cat' for Add a keyword
And I enter and choose free text 'Top Stories' for Add a collection
And I enter and choose free text 'The Sun' for Add a company

@all
Scenario: Select a Lead Image
Given I click on EDIT button for LEAD IMAGE
Then the LEAD IMAGE modal opens
And I choose LEAD IMAGE item 1
And I enter free text 'Dogs Trust Ireland' for Image Source
And I enter free text 'https://www.youtube.com/channel/UCol_SfTRucAoUGlQgFgw7qA' for Image Website
And I click modal button SET LEAD IMAGE
#And I click 'X' on the LEAD IMAGE modal
And I click modal button CLOSE
Then the LEAD IMAGE modal is closed

@all
Scenario: Crop a Lead Image
Given I click on CROP button for LEAD IMAGE
Then the CROP IMAGE modal opens
And I move the crop slider to 50%
And I click modal button CROP IMAGE
#And I click 'X' on the CROP IMAGE modal
And I click modal button CLOSE
Then the CROP IMAGE modal is closed

@all
Scenario: Update Contacts
Given I remove all CONTACTS
And I search for CONTACT:Dogs Trust Ireland
# "//div[contains(@class,'story-contacts-item ember-view')]"
And I click ADD TO STORY button for CONTACTS SEARCH:result 2
And I click EDIT button for CONTACT:1
Then the ACTIVATE CONTACT modal opens
And I enter free text 'Dogs Trust Ireland - Dublin' for Name *
And I click modal button CLOSE

@all
Scenario: Add Contact
Given I click on ADD NEW CONTACT button for CONTACTS
Then the CREATE CONTACT modal opens
And I enter free text 'Dogs Trust Ireland - Dublin' for Name *
And I click modal button CLOSE

@all
Scenario: Update Checked Status
Given I click on MARK AS CHECKED button for CHECKS
Then the CURRENT STATUS is CHECKED
And I expand LOG OF CHECKS
And I see row 'A FEW SECONDS' in LOG OF CHECKS
And I delete all rows from LOG OF CHECKS
Then the CURRENT STATUS is NOT CHECKED

@all @edit_story_1 @reorder_items_1
Scenario: Reorder items by dragging
Given slider:LEAD IMAGE is set to ON
And slider:LEAD IMAGE is set to OFF
And I drag an item from position 6 to position 5
And I drag an item from position 5 to position 4
And I drag an item from position 4 to position 3
And I drag an item from position 3 to position 2
And I drag an item from position 2 to position 1
And I drag an item from position 1 to position 6

@all
Scenario: Update Edit
And I expand EDIT
