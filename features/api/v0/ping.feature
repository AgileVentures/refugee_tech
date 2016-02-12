Feature: Ping
  I want to ping the service and get a response back in different formats

  Scenario: Returning a JSON response
    Given: The API is running
    When the Accept Type is application/json
    And the client requests GET /api/v0/ping
    Then a "200" status code is returned
    And the response should be JSON:
      """
        { "message": "Pong" }
      """

  Scenario: Returning a text response
    Given: The API is running
    When the Accept Type is text/plain
    And the client requests GET /api/v0/ping
    Then a "200" status code is returned
    And the response should be: "Pong"
