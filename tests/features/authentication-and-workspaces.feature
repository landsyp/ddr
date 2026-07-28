@auth @tenant @critical
Feature: Authentication and organization workspaces
  As a WeSERVE operator
  I want secure access to my organization's workspace
  So that every donor, donation, receipt, and setting is isolated by tenant

  Background:
    Given the WeSERVE SaaS app is available

  @smoke
  Scenario: Seeded administrator signs in
    Given I am on the login screen
    When I sign in with the seeded administrator credentials
    Then I should land on the Overview dashboard
    And the app should store an authenticated session token
    And the sidebar should show the active organization workspace

  Scenario: Invalid credentials are rejected
    Given I am on the login screen
    When I sign in with an invalid password
    Then I should see an invalid email or password error
    And I should remain signed out

  Scenario: Forgot password response does not reveal whether an email exists
    Given I open the forgot password form
    When I submit any email address
    Then I should see the generic reset instruction message
    And the response should not disclose whether the email belongs to a user

  @tenant
  Scenario: New organization workspace registration creates an isolated tenant
    Given I open Create organization workspace
    When I submit a unique charity, registration number, administrator email, and valid password
    Then a new organization workspace should be created
    And default SaaS accounts should be added to that workspace
    And I should be signed in as the new workspace administrator

  Scenario: Registration requires a unique email and strong-enough password
    Given an administrator account already exists for an email
    When I register another organization with the same email
    Then the app should reject the duplicate email
    When I register with a password shorter than 8 characters
    Then the app should reject the weak password

  Scenario: Logout clears the local session
    Given I am signed in
    When I log out
    Then local session data should be removed
    And I should return to the login screen

  Scenario: Inactive or expired organizations cannot authenticate
    Given an organization is inactive or past its license date
    When a user from that organization tries to sign in
    Then authentication should be blocked
    And no workspace data should be returned

  Scenario: Login language toggle switches visible copy
    Given I am on the login screen in English
    When I switch the language to French
    Then login headings, buttons, and helper text should appear in French
