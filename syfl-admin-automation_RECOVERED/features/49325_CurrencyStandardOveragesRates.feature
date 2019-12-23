Feature: 49325 - Input for currency, standard rate and overages

  Background:
    #Given I am on the Login page
    #And I log in as a valid user

@49325 @all
Scenario: Verify fields and currencies
Given I open the new company page
And I log in as a valid user
Then the currency, standard rate and overages fields appear with the following labels and default text:
|Contract Currency	|Select currency|
|Standard Rate      |	0.00          |
|Overages Rate      |	0.00          |
And only the following 5 currencies are listed for Contract Currency:
|USD|
|CAD|
|AUD|
|GBP|
|EUR|

@49325 @all
Scenario: Max 2 decimal places
Given I edit a company '1133'
When I configure the following rates values
|Standard Rate      |	1.234          |
|Overages Rate      |	3.456          |
And I click Save
Given I edit a company '1133'
Then the currency, standard rate and overages fields appear with the following labels and default text:
|Standard Rate      |	1.23          |
|Overages Rate      |	3.46          |

@49325 @all
Scenario: Save values
Given I edit a company '1133'
When I configure the following rates values
|Contract Currency	|USD            |
|Standard Rate      |	1.23          |
|Overages Rate      |	3.45          |
And I click Save
And I edit a company '1133'
Then the currency, standard rate and overages fields appear with the following labels and default text:
|Contract Currency	|USD            |
|Standard Rate      |	1.23          |
|Overages Rate      |	3.45          |

@49325
Scenario: No negative values
Given I edit a company '1133'
When I configure the following rates values
|Contract Currency	| USD           |
|Standard Rate      |	-1.00         |
|Overages Rate      |	-1.00         |
And I click Save
Then a validation error appears containing text 'Value must be greater than or equal to 0.'

@49325
Scenario: No validation error when no currencies configured
Given I edit a company '1133'
When I configure the following rates values
|Contract Currency	| USD           |
|Standard Rate      |	0.00          |
|Overages Rate      |	0.00          |
And I click Save
Then I do not see a validation error

#@49325 @all
Scenario: Not a real test - just logging out to stop pending tests from holding onto login 
And I logout
