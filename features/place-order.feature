Feature: Place order
  Scenario: Ordering
    Given I go to "/shop"
    When I click "#add-btn"
    And I click "#checkout"
    Then I see "Thank you"

  Scenario: Shipping costs for a small order
    Given a customer has products worth 30 euros in the shopping cart
    When the customer confirms the order
    Then the customer pays 4.95 euros in shipping costs

  Scenario: Shipping costs for a large order
    Given a customer has products worth 60 euros in the shopping cart
    When the customer confirms the order
    Then the customer pays 0 euros in shipping costs
