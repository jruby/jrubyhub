Feature: Item model
  In order to track news items related to JRuby
  A JRuby.org user
  should be able to manipulate items

  Scenario: View item
    Given an item with contents: New JRuby Release!

    When I am on the items page

    Then I should see "New JRuby Release!"

  Scenario: Create item
    Given I am on the items page

    When I follow "Create New Item"
    And I fill in "Content" with "New JRuby Blog Post!"
    And press "Create Item"

    Then I should see "New JRuby Blog Post!"
    And I should see "added your item!"
