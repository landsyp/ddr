@saas @billing @security @api @audit
Feature: SaaS platform readiness
  As a workspace owner
  I want subscription, billing, security, API, webhook, onboarding, and audit controls
  So that the donation product can operate as a real SaaS business

  Background:
    Given I am signed in as an organization admin
    And my organization data is isolated from other tenants

  Scenario: View the SaaS subscription control center
    When I open the Subscription page
    Then I should see the current plan, renewal amount, and billing cycle
    And I should see usage meters for seats, donors, donations, and receipts
    And I should see the onboarding checklist

  Scenario: Change subscription plan with a quality gate
    Given the Gold plan is active
    When I choose the Premium annual plan
    Then the subscription should update to Premium
    And the renewal amount should use annual billing
    And the audit log should record the subscription update

  Scenario: Add a billing payment method
    When I add a cardholder, card number, and expiry date
    Then only the card brand and last four digits should be stored
    And the payment method should appear in the billing center
    And the onboarding checklist should mark billing as complete

  Scenario: Prevent deleting the default payment method
    Given a default payment method exists
    When I try to delete the default payment method
    Then the request should be rejected
    And the payment method should remain active

  Scenario: Review invoices in the billing center
    Given invoices exist for the tenant
    When I open organization settings
    Then I should see invoice number, date, amount, status, and description
    And no other tenant invoices should be visible

  Scenario: Update tenant security posture
    When I require MFA, set password length, set session timeout, and add allowed email domains
    Then the security settings should be saved for the current tenant
    And the audit log should record the security settings update

  Scenario: Create and revoke an API key
    When I create an API key with donation and donor scopes
    Then the full secret should be shown only once
    And only the key prefix and scopes should remain visible later
    When I revoke the API key
    Then the key should become inactive
    And the audit log should record the revocation

  Scenario: Create and test a webhook endpoint
    When I add an HTTPS webhook for donation and receipt events
    Then the webhook endpoint should appear with its event subscriptions
    When I send a webhook test
    Then the latest delivery status should show the test result
    And the audit log should record the webhook test

  Scenario: Track onboarding checklist progress
    Given onboarding tasks exist for profile, users, accounts, payments, receipts, and security
    When I complete or reopen an onboarding task
    Then only the current tenant task should change
    And the SaaS overview should return the updated checklist

  Scenario: Restrict SaaS administration to admins
    Given I am signed in as a standard user
    When I call subscription, billing, API key, webhook, or security administration endpoints
    Then the API should return admin access required
    And no SaaS control data should be changed
