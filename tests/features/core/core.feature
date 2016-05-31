@api
  Feature: Test DrupalContext
    In order to prove the Drupal context using the blackbox driver is working properly
    As a developer
    I need to use the step definitions of this context

    Scenario: Create a node
      Given I am logged in as a user with the "administrator" role
      When I am viewing an "article" content with the title "My article"
      Then I should see the heading "My article"

    Scenario: Run cron
      Given I am logged in as a user with the "administrator" role
      When I run cron
      And am on "admin/reports/dblog"
      Then I should see the link "Cron run completed"
