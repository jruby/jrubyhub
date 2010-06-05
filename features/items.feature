Feature: Items
  In order to contribute news items related to JRuby
  A JRuby.org user
  should be able to manipulate items

  Scenario: View item
    Given an item with content: New JRuby Release!
    When I am on the items page
    Then I should see "New JRuby Release!"
    And I should see "Posted less than a minute ago"

  Scenario: Create item
    Given I am on the items page
    When I follow "Create New Item"
    And I fill in "item_content" with "New JRuby Blog Post!"
    And press "Create Item"
    Then I should see "New JRuby Blog Post!"
    And I should see "added your item!"
