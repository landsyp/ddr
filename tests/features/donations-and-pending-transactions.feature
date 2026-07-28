@donations @pending @critical
Feature: Donations and pending incoming transactions
  As an operator
  I want to record manual gifts and categorize imported transactions
  So that the donation register stays accurate

  Background:
    Given I am signed in as an administrator
    And I am on the Donations screen

  @smoke
  Scenario: Record a manual donation
    Given an active donor and account exist
    When I enter donor, account, amount, date, method, and description
    Then the donation should be added to the register
    And dashboard totals should refresh

  Scenario: Donation receipt status is Ready when donor and account are eligible
    Given a donor has receipts enabled
    And the selected account is receiptable
    When I record a donation
    Then the donation receipt status should be Ready

  Scenario: Donation receipt status is No receipt when donor or account is not eligible
    Given a donor has receipts disabled or the selected account is not receiptable
    When I record a donation
    Then the donation receipt status should be No receipt

  Scenario: Update a donation
    Given a donation exists
    When I edit the donor, account, amount, date, method, or description
    Then the donation should be updated
    And any previous receipt link should be cleared for recalculation

  Scenario: Delete a donation
    Given a donation exists
    When I confirm donation deletion
    Then the donation should be removed from the register
    And dashboard totals should refresh

  Scenario: Search the donation register
    Given donations exist for multiple donors and accounts
    When I search by donor, account, date, or description
    Then only matching donation rows should be shown

  Scenario: View account mix and donation totals
    Given donations exist across multiple accounts
    When I open Donations
    Then the account mix should show totals by account
    And the donation summary should show total donations, total amount, year-to-date amount, and average gift

  Scenario: Pending imported donations are visible for categorization
    Given pending incoming transactions exist
    When I open pending donations
    Then each pending transaction should show imported date, amount, source note, and detected donor if available

  Scenario: Categorize a pending donation
    Given a pending incoming transaction exists
    And an active donor and account exist
    When I assign the pending transaction to the donor and account
    Then a donation should be created
    And the pending transaction should be removed from the pending list

  Scenario: Pending donation cannot be categorized with an unknown donor or account
    Given a pending incoming transaction exists
    When I categorize it with an unrecognized donor or account
    Then the app should reject the categorization
    And the transaction should remain pending

  Scenario: Import donation panel is available
    When I open the import donations area
    Then I should see guidance for CSV, Excel, PayPal, or bank export files
    And I should be able to choose a file for future import processing
