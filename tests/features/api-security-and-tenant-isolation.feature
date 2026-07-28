@api @security @tenant @critical
Feature: API security and tenant isolation
  As a SaaS owner
  I want every API route protected and tenant scoped
  So that organizations cannot see or modify each other's records

  Background:
    Given the API server is available

  @smoke
  Scenario: Health endpoint is public
    When I request API health without a token
    Then I should receive ok true
    And I should see the configured SQLite database path

  Scenario: Protected endpoints require a bearer token
    When I request bootstrap, dashboard, organization, donors, accounts, donations, receipts, reports, users, banking connections, or accounting integrations without a token
    Then each response should require authentication

  Scenario: Admin-only endpoints reject standard users
    Given I am authenticated as a standard user
    When I try to update organization, users, accounts, banking connections, or accounting integrations
    Then the API should return admin access required

  Scenario: Tenant scoped donor operations
    Given two organizations exist
    When organization A creates, updates, archives, searches, or deletes a donor
    Then organization B should never see or modify that donor

  Scenario: Tenant scoped financial operations
    Given two organizations exist
    When organization A creates accounts, donations, receipts, pending categorization, reports, banking connections, and accounting integrations
    Then organization B should never see or modify organization A financial records

  Scenario: Subscription request endpoint is public but does not expose workspace data
    When I submit a subscription request without a token
    Then the request should be stored
    And no authenticated workspace data should be returned

  Scenario: Logout invalidates only the current session token
    Given a user has two active sessions
    When one session logs out
    Then that token should stop working
    And the other token should remain valid

  Scenario: Unknown routes return not found
    When I request an unknown API route
    Then the API should return route not found
