@navigation @dashboard @notifications
Feature: Navigation, dashboard, and notifications
  As a signed-in user
  I want clear navigation, search, notifications, and dashboard summaries
  So that I can move through operational work quickly

  Background:
    Given I am signed in as an administrator

  @smoke
  Scenario: Dashboard loads current workspace data
    When I open the Overview dashboard
    Then I should see year-to-date donations
    And I should see receipt count
    And I should see active donor count
    And I should see pending receipt count

  Scenario: Sidebar navigation opens every major app area
    When I use the sidebar
    Then I can open Overview, Donations, Donors, Accounts, Receipts, Reports, Connections, Integrations, Subscription, and Customization
    And I can open Support and Settings from the sidebar footer

  Scenario: Quick actions route to operational screens
    Given I am on the Overview dashboard
    When I choose Add donation
    Then the Donations screen should open
    When I choose Add donor
    Then the Donors screen should open
    When I choose Generate receipts
    Then the Receipts screen should open
    When I choose Generate report
    Then the Reports screen should open

  Scenario: Top search filters workspace records
    Given donors, donations, accounts, and receipts exist
    When I enter a search term in the top search box
    Then matching donors should be shown in Donors
    And matching donations should be shown in Donations
    And active account and receipt lists should be filtered when those screens are open

  Scenario: Notification bell lists pending donation work
    Given imported pending donations exist
    When I open notifications
    Then I should see a pending donation notification
    When I select the notification
    Then the Donations screen should open with pending donations visible

  Scenario: Empty notifications show current data status
    Given there are no pending donations or alerts
    When I open notifications
    Then I should see that donation and receipt data are current

  Scenario: Profile chip opens organization settings
    When I choose the profile chip
    Then the Settings screen should open
    And my account role should be visible

  Scenario: Application language toggle switches workspace labels
    Given I am signed in in English
    When I switch the workspace language to French
    Then navigation labels and page headings should appear in French

  Scenario: Tables support sorting and pagination where enabled
    Given a table has more rows than one page
    When I change the sort order
    Then the rows should reorder by the selected column
    When I move to the next page
    Then the next group of rows should be visible
