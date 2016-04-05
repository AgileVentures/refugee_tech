Feature: As a system administrator
  In order to be able to match users using their common interests
  I would like to allow users to add tags to their profile

  As a user
  In order to make my profile more descriptive
  I would like to tag myself with competence tags

  https://www.pivotaltracker.com/story/show/113903923

  Background:
    Given the following users exist
      | user_name | email           | password     | password_confirmation |
      | Thomas    | thomas@mail.com | password1    | password1             |
    Given the following tags exists
      | name    |
      | rspec   |
      | testing |
      | html    |
    Given the admin account is set up
    Given I am logged in as admin
    Given I click on "Users"

  Scenario: Create a user
    And I click on "Create User"
    And I fill in "User name" with "Anders"
    And I fill in "Email" with "anders@anders.com"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I fill in "Skill list" with "java, ruby, html"
    And I click on "Create user"
    Then I should see "User was successfully created"
    Then the updated users skills should be "java, ruby, html"

  Scenario: Update user by adding tags
    Given "Thomas" skills are "rspec, testing"
    And I click on "Edit" for "Thomas"
    And I fill in "Skill list" with "java, ruby, html"
    And I click on "Update user"
    Then I should see "User was successfully updated"
    Then the updated users skills should be "rspec, testing, java, ruby, html"

  @javascript
  Scenario: Update skills removing and adding tags
    Given "Thomas" skills are "testing"
    And I click on "Edit" for "Thomas"
    And I delete the content of "user_skill_list"
    And I set skill tags to "html"
    And I click on "Update user"
    Then I should see "User was successfully updated"
    Then the updated users skills should be "html"

