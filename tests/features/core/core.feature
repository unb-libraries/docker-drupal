# Basic functionality testing.
# Ref : phase2/behat-suite
# https://github.com/phase2/behat-suite/blob/master/example/behat/default.feature

@api
Feature: Core
  In order to know the website is running
  As a website user
  I need to be able to view the site title and login

@api @login
Scenario: As a logged in user
  Given I am logged in as a user with the "administrator" role
  When I visit "/admin"
  Then I should see the link "Content"

  Scenario: Viewing the site title
    Given I am on the homepage
    Then I should see "Welcome to"

  Scenario: See "Add Content"
    Given I am logged in as a user with the "administrator" role
    And I am on the homepage
    When I follow "Add content"
    Then I should see "Basic Page"

  Scenario: Create many nodes
    Given "page" content:
    | title    |
    | Testsuite Page one |
    | Testsuite Page two |
    And "article" content:
    | title          |
    | Testsuite First article  |
    | Testsuite Second article |
    And I am logged in as a user with the "administrator" role
    When I go to "admin/content"
    Then I should see "Testsuite Page one"
    And I should see "Testsuite Page two"
    And I should see "Testsuite First article"
    And I should see "Testsuite Second article"

  Scenario: Create nodes with fields
    Given "article" content:
    | title                     | promote | body             |
    | Testsuite First article with fields |       1 | PLACEHOLDER BODY |
    When I am on the homepage
    And follow "Testsuite First article with fields"
    Then I should see the text "PLACEHOLDER BODY"

  Scenario: Create and view a node with fields
    Given I am viewing an "Article" content:
    | title | My article with fields! |
    | body  | A placeholder           |
    Then I should see the heading "My article with fields!"
    And I should see the text "A placeholder"

  Scenario: Create users
    Given users:
    | name     | mail            | status |
    | Testsuite User | testsuite@example.com | 1      |
    And I am logged in as a user with the "administrator" role
    When I visit "admin/people"
    Then I should see the link "Testsuite User"

  Scenario: Login as a user created during this scenario
    Given users:
    | name      | status |
    | Testsuite user |      1 |
    When I am logged in as "Testsuite user"
    Then I should see the link "Log out"

  Scenario: Create a term
    Given I am logged in as a user with the "administrator" role
    When I am viewing a "tags" term with the name "Testsuite tag"
    Then I should see the heading "Testsuite tag"

  Scenario: Create many terms
    Given "tags" terms:
    | name    |
    | Testsuite Tag one |
    | Testsuite Tag two |
    And I am logged in as a user with the "administrator" role
    When I go to "admin/structure/taxonomy/tags"
    Then I should see "Testsuite Tag one"
    And I should see "Testsuite Tag two"

  Scenario: Create nodes with specific authorship
    Given users:
    | name     | mail            | status |
    | Testsuite User | testsuite@example.com | 1      |
    And "article" content:
    | title          | author   | body             | promote |
    | Article by Testsuite | Testsuite User | PLACEHOLDER BODY | 1       |
    When I am logged in as a user with the "administrator" role
    And I am on the homepage
    And I follow "Article by Testsuite"
    Then I should see the link "Testsuite User"

  Scenario: Create an article with multiple term references
    Given "tags" terms:
    | name      |
    | Testsuite Tag one   |
    | Testsuite Tag two   |
    | Testsuite Tag three |
    | Testsuite Tag four  |
    And "article" content:
    | title | body | promote | field_tags |
