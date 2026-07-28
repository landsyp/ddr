@accounts @critical
Feature: Account management
  As an administrator
  I want to manage donation accounts and receipt eligibility
  So that gifts are categorized correctly and receipting rules are reliable

  Background:
    Given I am signed in as an administrator
    And I am on the Accounts screen

  @smoke
  Scenario: Add a receiptable account
    When I create an account with a unique account number and receipt eligibility enabled
    Then the account should appear in the account list
    And the account should be marked Receiptable

  Scenario: Add a non-receiptable account
    When I create an account with receipt eligibility disabled
    Then the account should be marked No receipt
    And donations in that account should not be receipt-ready

  Scenario: Duplicate account numbers are rejected
    Given an account already exists with number "100"
    When I create another account with number "100"
    Then the app should show the duplicate account error

  Scenario: Edit an account
    Given an account exists
    When I change the account number, name, and receipt eligibility
    Then the account list should show the updated details
    And existing donations should remain linked to the account

  Scenario: Toggle receipt eligibility from the account list
    Given a receiptable account exists
    When I toggle the receipt eligibility pill
    Then the account should become non-receiptable
    When I toggle it again
    Then the account should become receiptable

  Scenario: View account detail and donation history
    Given an account has donations
    When I expand the account details
    Then I should see account totals and donations in this account

  Scenario: Delete an unused account
    Given an account has no linked donations
    When I confirm account deletion
    Then the account should be removed

  Scenario: Prevent deleting an account with donations
    Given an account has at least one linked donation
    When I try to delete the account
    Then deletion should be blocked
    And the account should remain available for historical reporting
