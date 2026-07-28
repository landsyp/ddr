@reports @templates @critical
Feature: Reports and reusable report templates
  As an operator
  I want to generate operational reports and save templates
  So that finance and leadership reporting is repeatable

  Background:
    Given I am signed in as an administrator
    And I am on the Reports screen

  @smoke
  Scenario Outline: Generate donation reports by grouping
    Given donations exist in the selected period
    When I run a Donations report grouped by "<grouping>"
    Then the report should show summary rows with counts and totals
    And the report should show source donation rows

    Examples:
      | grouping     |
      | date         |
      | month        |
      | account      |
      | accountMonth |
      | donor        |
      | method       |

  Scenario: Generate donor report
    Given donors exist
    When I run a Donors report
    Then the report should show donor rows and giving totals

  Scenario: Generate account report
    Given accounts exist
    When I run an Accounts report
    Then the report should show account rows, donation counts, totals, and receipt eligibility

  Scenario: Generate receipt report
    Given receipts exist in the selected period
    When I run a Receipts report
    Then the report should show receipt rows, donor names, receipt numbers, periods, amounts, and statuses

  Scenario: Export report results
    Given a report has generated rows
    When I export the report
    Then the downloaded file should contain the visible report data

  Scenario: Built-in report templates prefill report settings
    Given built-in templates are visible
    When I select Detailed donations, Monthly YTD summary, Accounts by month, Donor totals, Account totals, or Receipt list
    Then the report builder should use the template type and grouping

  Scenario: Create a custom report template
    When I save a custom report template with name, description, type, and grouping
    Then the custom template should appear in Custom reports
    And it should be available after refreshing workspace data

  Scenario: Create an automatic weekly report template
    When I create a custom report template with automatic generation enabled weekly
    Then the template should store weekly frequency and selected weekday

  Scenario: Create an automatic monthly report template
    When I create a custom report template with automatic generation enabled monthly
    Then the template should store monthly frequency and selected day

  Scenario: Custom report template requires a name
    When I save a custom report template without a name
    Then the app should reject the template
    And no custom template should be created
