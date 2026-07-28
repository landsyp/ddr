@receipts @critical
Feature: Receipt generation and delivery status
  As an operator
  I want to generate receipt batches from eligible gifts
  So that official receipts can be emailed, printed, and tracked

  Background:
    Given I am signed in as an administrator
    And I am on the Receipts screen

  @smoke
  Scenario: Generate email receipt batch for eligible donations
    Given eligible donations exist in the selected period
    When I generate receipts in Email mode
    Then one receipt should be created per eligible donor
    And included donations should be linked to their receipt
    And valid donor emails should start with an in-progress delivery status

  Scenario: Generate print receipt batch
    Given eligible donations exist in the selected period
    When I generate receipts in Print mode
    Then created receipt deliveries should start with To print status

  Scenario: Invalid donor email is flagged during email receipt generation
    Given an eligible donor has an invalid or missing email address
    When I generate receipts in Email mode
    Then the donor receipt should be created
    And the delivery status should be Invalid email

  Scenario: No eligible rows shows a clear message
    Given no eligible donations exist in the selected period
    When I generate receipts
    Then no receipt should be created
    And I should see that no eligible receipt rows were found

  Scenario: Regenerating the same donor and period replaces the previous receipt
    Given a receipt already exists for a donor and exact period
    When I generate receipts again for that same period
    Then the previous receipt for that donor and period should be replaced
    And the donor donations should point to the newest receipt

  Scenario: Mark receipt delivery as sent
    Given a receipt delivery exists
    When I mark the receipt as sent
    Then the receipt status should update to delivered

  Scenario: Receipt metrics and batches refresh after generation
    Given a receipt batch is generated
    When I view the Receipt center
    Then stored receipts, ready gifts, batches, and review counts should be refreshed
    And the Batches table should show created date, period, count, and total

  Scenario: Receipt generation respects donor and account eligibility
    Given donations exist for active, inactive, receipt-disabled, and non-receiptable account combinations
    When I generate receipts
    Then only active donors with receipts enabled and receiptable accounts should be included
