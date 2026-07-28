@selfserve @payments @donations @api @critical
Feature: Self-serve donor giving with payment gateway
  As a donor and organization administrator
  I want donors to open a tap or QR giving page with their donor number
  So that gifts are confirmed, paid, and recorded without staff entering them manually

  Scenario: Donor opens a tap or QR giving page
    Given online giving is enabled for the organization
    And the donor has an active donor number
    When the donor opens the self-serve giving link from a phone tap or QR code
    Then the public page should show the organization name
    And the donor should be able to enter their donor number without logging in
    And the payment gateway status should be visible

  Scenario: Donor number resolves the donor profile safely
    Given a donor number belongs to an active donor in the organization
    When the donor looks up that donor number on the public giving page
    Then the page should show the donor name and available donation funds
    And private admin-only workspace data should remain hidden

  Scenario: Donor confirms a card gift through the gateway
    Given the public giving page has found the donor
    And the donor chooses a donation fund and amount
    When the donor taps the phone payment action and the gateway approves the payment
    Then the donor should see a confirmation number
    And the confirmation should show the amount, fund, donor, and receipt status
    And the payment should be stored with the gateway reference

  Scenario: Self-serve gift appears in the donation register
    Given a self-serve gateway payment is approved
    When an organization user opens the donation register
    Then the new donation should appear with Card as the method
    And the donation description should identify it as a self-serve online gift
    And receipt readiness should be calculated from donor and account eligibility

  Scenario: Administrator generates a phone tap donation link
    Given an organization administrator is on the donations page
    When the administrator opens the self-serve giving drawer
    Then they should see the connected payment gateway mode and status
    And they should be able to choose a donor number
    And they should be able to copy or open the tap or QR donation link

  Scenario: Recent self-serve confirmations are visible to administrators
    Given donors have completed self-serve gifts
    When an organization administrator opens the self-serve giving drawer
    Then recent confirmation numbers should be listed
    And each confirmation should show the donor, amount, account, and gateway status

  Scenario: Invalid self-serve payment requests are rejected
    Given the public giving endpoint is available
    When a request uses an unknown donor number, invalid account, or amount below one dollar
    Then the API should reject the request
    And no donation should be recorded

  Scenario: Gateway can be prepared for live provider integration
    Given an organization administrator has gateway credentials for a supported provider
    When they save the provider, mode, public key, and merchant account metadata
    Then the self-serve giving portal should expose the provider status
    And live card details should still be handled by the external gateway, not stored in WeSERVE
