@donors @critical
Feature: Donor management
  As an operator
  I want to maintain donor profiles, donor status, and donor exports
  So that donations and receipts are tied to accurate donor data

  Background:
    Given I am signed in as an administrator
    And I am on the Donors screen

  @smoke
  Scenario: Add a donor with automatic donor number
    When I create a donor without entering a donor number
    Then the next available donor number should be assigned
    And the donor should appear in the directory
    And the success notice should say the donor was saved

  Scenario: Add a donor with receipt and member preferences
    When I create a donor with Member enabled and Receipts enabled
    Then the donor directory should show Member as Yes
    And the donor directory should show Receipts as Yes

  Scenario: Duplicate donor numbers are rejected
    Given a donor already exists with number "1001"
    When I create another donor with number "1001"
    Then I should see a duplicate donor number error
    And the original donor should remain unchanged

  Scenario: Update a donor profile from the side panel
    Given a donor exists
    When I edit the donor contact fields
    Then the donor profile should be updated
    And the donor directory should show the new values

  Scenario: Search and filter the donor directory
    Given active, inactive, member, and receipt-enabled donors exist
    When I search by donor name, number, city, or email
    Then only matching donors should be shown
    When I enable the Member filter
    Then only member donors should remain
    When I enable the Receipts filter
    Then only receipt-enabled donors should remain

  Scenario: View donor details and donation history
    Given a donor has donation history
    When I expand the donor profile
    Then I should see donor totals, average donation, ready receipts, and donation history

  Scenario: Archive and reactivate a donor
    Given an active donor exists
    When I archive the donor
    Then the donor should become inactive
    When I reactivate the donor
    Then the donor should become active again

  Scenario: Delete donor without activity
    Given a donor has no donations, receipts, or delivery records
    When I confirm donor deletion
    Then the donor should be removed from the directory

  Scenario: Prevent deleting donor with activity
    Given a donor has at least one donation or receipt
    When I try to delete the donor
    Then the app should reject deletion
    And it should recommend making the donor inactive instead

  Scenario: Export visible donors
    Given the donor directory is filtered
    When I export donors as CSV
    Then the CSV should include only visible donor rows
    When I export donors as Excel
    Then the Excel download should include only visible donor rows

  Scenario: Donor page tour explains available tools
    When I start the donor page tutorial
    Then I should see steps for search and export, add donor tab, stats tab, and editing donors
