@javascript
Feature: Sell walkup tickets

  As a boxoffice worker
  I want to sell tickets to walkup customers
  So that we can maximize seat counts

  Background:
    Given I am logged in as boxoffice
    And a show "The Nerd" with the following tickets available:
    | qty | type    | price  | showdate                |
    |   3 | General | $11.00 | October 1, 2015, 7:00pm |
    And I am on the walkup sales page for October 1, 2015, 7:00pm

  Scenario: purchase 2 tickets with cash

    When I select "2" from "General"
    And I choose "Cash or Zero-Revenue"
    And I press "Record Cash Payment or Zero Revenue Transaction"
    Then I should see "2 tickets (total $22.00) paid by Cash"
    And I should see "General (1 left)"
    And I should be on the walkup sales page for October 1, 2015, 7:00pm

  Scenario: purchase 2 tickets with check
  
    When I select "2" from "General"
    And I choose "Check"
    And I press "Record Check Payment"
    Then I should see "2 tickets (total $22.00) paid by Check"
    And I should see "General (1 left)"
    And I should be on the walkup sales page for October 1, 2015, 7:00pm

@stubs_successful_credit_card_payment
  Scenario: purchase 2 tickets with valid credit card info

    When I select "2" from "General"
    And I choose "Credit Card"
    And I fill in a valid credit card for "John Doe"
    And I press "Charge Credit Card"
    Then I should see "2 tickets (total $22.00) paid by Credit card"
    And I should see "General (1 left)"
    And I should be on the walkup sales page for October 1, 2015, 7:00pm

@stubs_failed_credit_card_payment
  Scenario: attempt purchase with invalid credit card

    When I select "2" from "General"
    And I fill in an invalid credit card for "John Doe"
    And I press "Charge Credit Card"
    Then I should see "Transaction NOT processed"
    And I should see "General (3 left)"
    And I should be on the walkup sales page for October 1, 2015, 7:00pm
