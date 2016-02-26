Feature: As a system admin
  In order to be able to perform CRUD actions on users
  I would like to be able to access them through Godmin interface

  Background:
    Given the following users exist
      | user_name | email           | password     | password_confirmation |
      | Thomas    | thomas@mail.com | password1    | password1             |
      | Mazen     | mazen@gmail.com | password2    | password2             |
      | Tarek     | tarek@gmail.com | password3    | password3             |
      | Ivan      | ivan@hotmai.com | password4    | password4             |
    Given the admin account is set up
    Given I am logged in as admin
    Given I click on "Users"

  Scenario: View Users index
    Then I should see "Thomas"
    And I should see "Mazen"
    And I should see "Tarek"
    And I should see "Ivan"

  Scenario: View user
    And I click on "Show" for "Mazen"
    Then I should see "Mazen"
    And I should see "mazen@gmail.com"
    And I should see "Created at"
    And I should see "mazen" in the url

  Scenario: Create a user
    And I click on "Create User"
    And I fill in "User name" with "Tony"
    And I fill in "Email" with "tony@outlook.com"
    And I fill in "Password" with "password5"
    And I fill in "Password confirmation" with "password5"
    And I click on "Create User"
    Then I should see "User was successfully created"
    And I should see 5 instances of User

  Scenario: Update user
    And I click on "Edit" for "Thomas"
    And I fill in "User name" with "Thomas Ochman"
    And I fill in "Email" with "tochman@newmail.com"
    And I click on "Update User"
    Then I should see "User was successfully updated"
    And I should see "Thomas Ochman"
    And I should see "tochman@newmail.com"

  Scenario: Delete user
    And I click on "Destroy" for "Ivan"
    Then I should see "User was successfully destroyed"
    And I should see 3 instances of User
