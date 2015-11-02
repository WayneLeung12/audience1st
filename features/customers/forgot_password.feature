Feature: customer who forgot password can receive a new one by email

  As a customer who forgot my password
  So that I can login
  I want to generate a new password by email

Scenario: reset password and login with new one

  Given customer "John Doe" exists and was created by admin
    | first_name       | last_name    | email        | created_by_admin |
    | John             | Doe          | john@doe.com | true             |
  When I visit the forgot password page
  And I fill in "email" with "john@doe.com"
  And I press "Reset My Password By Email"
  Then an email should be sent to "john@doe.com" containing a password
  And I should be able to login with username "john@doe.com" and that password
