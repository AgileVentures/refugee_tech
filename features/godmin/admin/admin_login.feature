Feature: Admin can login into admin panel
  As a site admin
  So that I can supervise the application
  I want to be able to login into application admin panel
  
  Background:
    Given the admin user exsist
    And I am on the root page
  
  Scenario: login into the admin panel
    And I fill in the login form with my creadentials
    And I click on "Sign in"
    Then I should see "Welcome to Project Unify"
    
    