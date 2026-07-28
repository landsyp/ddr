@settings @users @billing @admin
Feature: Organization settings, users, and billing methods
  As an administrator
  I want to manage profile data, access seats, users, and billing methods
  So that the workspace remains secure and operational

  Background:
    Given I am signed in as an administrator
    And I am on the Settings screen

  @smoke
  Scenario: Update organization profile
    When I update organization name, registration number, contact, reply email, address, city, postal code, province, transit, and folio
    Then the organization profile should be saved
    And receipt-facing organization fields should use the updated values

  Scenario: Organization active flag is saved by administrators
    When I change the organization active flag
    Then the organization active value should be saved

  Scenario: User access summary shows plan seat limits
    Given the organization has a current plan
    When I open User access
    Then I should see active seats, included seats, and seats remaining

  Scenario: Seat limit blocks adding users when plan capacity is full
    Given the current plan has no seats remaining
    When I try to add another user
    Then the app should block the user creation form
    And the upgrade plan drawer should open

  Scenario: Add a user when seats are available
    Given the current plan has seats remaining
    When I add first name, last name, email, temporary password, and role
    Then the user should be added to the workspace
    And the user should appear in the Users table

  Scenario: Edit a user
    Given another user exists
    When I update the user's name, email, language, and admin role
    Then the user table should show the updated user

  Scenario: Deactivate and reactivate another user
    Given another active user exists
    When I deactivate the user
    Then that user should no longer be able to authenticate
    When I reactivate the user
    Then that user should be able to authenticate again

  Scenario: Current user cannot deactivate their own account from the user table
    Given I am viewing the Users table
    When I inspect my own user row
    Then my own user row should not show a deactivate action

  Scenario: Standard user cannot use admin-only settings actions
    Given I am signed in as a standard user
    When I open Settings
    Then admin-only organization, user, payment, connection, and integration controls should be hidden or rejected

  Scenario: Payment method tiles show default and non-default cards
    When I open Payment methods
    Then I should see default and non-default payment methods
    And the default method delete action should be disabled

  Scenario: Add payment method form can be opened and closed
    When I choose Add payment method
    Then cardholder, card number, expiry date, and CVC fields should be visible
    When I submit the add payment action
    Then the add payment form should close
