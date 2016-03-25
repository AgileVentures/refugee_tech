@javascript
Feature: As a user
  In order to be able match users
  I would like to have a matching method in place and be able to see a json response of potential users to connect with

  (This is about the admin interface for demo purposes)

  PT story: https://www.pivotaltracker.com/story/show/112745899

  Background:
    Given the following users exist
      | user_name | skills                        | mentor |
      | Thomas    | programming, cooking, Travels | true   |
      | Sam       | programming                   | true   |
      | Mazen     | sailing                       | false  |
      | Tarek     | Programming, politics         | false  |
      | Ivan      | programming                   | false  |
    Given the admin account is set up
    Given I am logged in as admin
    Given I click on "Users"

  Scenario: Hide Unify link on users#edit
    Given I click on "Edit" for "Thomas"
    And I click on "Actions"
    Then I should not see the link "Unify"

  Scenario: Display matches on user#show
    And I click on "Show" for "Thomas"
    And I click on "Actions"
    And I click on "Unify"
    Then I should see "Tarek"
    And I should see "Ivan"
    And I should not see "Mazen"
    And I should not see "Sam"

