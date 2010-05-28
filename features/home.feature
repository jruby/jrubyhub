Feature: Home page
  In order to see what's new in the JRuby community
  A JRuby.org visitor
  wants to see a list of recent items
  
  Scenario: Visit home page
    Given I am on the home page
    
    Then I should see a list of items
