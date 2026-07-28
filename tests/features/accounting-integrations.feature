@integrations @accounting
Feature: Accounting integrations
  As an administrator
  I want to prepare donation exports for accounting systems
  So that WeSERVE data can be synchronized with finance tools

  Background:
    Given I am signed in as an administrator
    And I am on the Integrations screen

  @smoke
  Scenario: Add QuickBooks Online integration
    When I add the QuickBooks Online accounting integration
    Then an integration card should be created
    And it should show API ready status
    And it should show the QuickBooks accounting scope

  Scenario: Add Xero integration
    When I add the Xero accounting integration
    Then an integration card should be created
    And it should show API ready status
    And it should show Xero scopes

  Scenario: Unsupported accounting provider is rejected
    When the API receives an unsupported accounting provider
    Then it should reject the integration request
    And no integration should be saved

  Scenario: Sync donations to accounting export payload
    Given an accounting integration exists
    And donations exist in the workspace
    When I sync donations
    Then the integration status should become Synced
    And last sync time should be recorded
    And the sync response should include donation count, total, payload type, and payload rows

  Scenario: Accounting integrations are tenant scoped
    Given another organization has an accounting integration
    When I view Integrations in my workspace
    Then I should only see integrations for my organization
