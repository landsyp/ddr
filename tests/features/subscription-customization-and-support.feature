@subscription @customization @support
Feature: Subscription, customization, and support
  As a workspace user
  I want plan information, branding controls, and support shortcuts
  So that the SaaS experience fits my organization

  Background:
    Given I am signed in as an administrator

  @smoke
  Scenario: Review subscription plans
    When I open Subscription
    Then I should see Basic, Gold, and Premium plan options
    And the current plan should be identified

  Scenario: Submit subscription change request
    Given I am on the Subscription screen
    When I submit charity, registration, contact, address, member, and security answer "70"
    Then the subscription request should be stored
    And I should see the subscription success message

  Scenario: Subscription security answer is required
    Given I am on the Subscription screen
    When I submit a subscription request with the wrong security answer
    Then the request should be rejected
    And I should see that the security answer must be 70

  Scenario: Apply built-in palette
    Given I am on the Customization screen
    When I choose Default, Evergreen, Harbor, or Plum
    Then the interface preview should use that palette
    And the current palette selection should update

  Scenario: Save a custom palette
    Given I am on the Customization screen
    When I enter a custom palette name and choose brand, accent, and highlight colors
    And I save the palette
    Then the palette should appear in Saved palettes
    And I should see the palette saved message

  Scenario: Settings shortcut opens customization
    Given I am on Settings
    When I open the customization shortcut drawer
    And I choose Customize interface
    Then the Customization screen should open

  Scenario: Support cards navigate to matching workflows
    Given I am on Support
    When I choose setup, account, donor, donation, report, or receipt help
    Then the matching app screen should open

  Scenario: Support contact is visible
    Given I am on Support
    When I review the support contact section
    Then I should see instructions to contact the account administrator for WeSERVE support
