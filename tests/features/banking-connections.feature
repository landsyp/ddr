@banking @connections
Feature: Bank, payment processor, and giving platform connections
  As an administrator
  I want to link incoming donation sources
  So that new gifts can be reviewed and categorized from connected sources

  Background:
    Given I am signed in as an administrator
    And I am on the Connections screen

  @smoke
  Scenario: Link a bank account for all SaaS accounts
    When I add a bank connection with institution, account number, transit, and routing details
    And I choose all SaaS accounts as the scope
    Then the connection should be saved
    And the linked bank tile should show the institution and masked account details

  Scenario: Link a bank account to selected SaaS accounts
    Given multiple SaaS accounts exist
    When I add a bank connection with selected account scope
    And I choose one or more SaaS accounts
    Then the connection should show only those linked account names

  Scenario Outline: Link a payment or giving source
    When I add a "<provider>" connection
    Then the connection should be saved with category "<category>"
    And sensitive identifiers should be masked in the tile

    Examples:
      | provider    | category  |
      | PayPal      | processor |
      | Stripe      | processor |
      | Zeffy       | giving    |
      | CanadaHelps | giving    |

  Scenario: Connection provider changes required fields
    When I switch provider between bank, PayPal, Stripe, and giving platform
    Then the form should show only the fields required for the selected provider

  Scenario: Connected source list is tenant scoped
    Given another organization has banking connections
    When I view Connections in my workspace
    Then I should only see connections for my organization

  Scenario: Pending donation count appears from connected sources
    Given connected sources have imported pending transactions
    When I open the app
    Then the top bar should show pending new donation count
    And the pending notification should link to Donations
