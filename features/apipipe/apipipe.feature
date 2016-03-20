Feature: As developer of PU API
  In order to make usage of my API easier
  I would like to make my api documentation accessible over internet

  Scenario: Access API documentation
    Given I visit the "api-doc" page
    Then I should see "Project Unify 1.0"
    And I should see "This describes the resources that make up the official Project Unify public API v1."