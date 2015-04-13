Feature: redeem promo codes

  As a customer
  So that I can save money on tickets
  I want to redeem promo codes

Background:
  
  Given a show "The Nerd" with the following tickets available:
  | qty | type    | price  | showdate                | 
  |   3 | General | $15.00 | October 1, 2010, 7:00pm | 
  |   2 | Special | $10.00 | October 1, 2010, 7:00pm | 
  And the "Special" tickets for "October 1, 2010, 7:00pm" require promo code "WXYZ"
  And I am not logged in
  And I go to the store page
  Then the "Discount Code" field should be blank
  And I should see "General" within "#voucher_menus"
  But I should not see "Special" within "#voucher_menus"

Scenario: redeem promo code redirects to tickets page

  When I fill in "Discount Code" with "wxyz"
  And I press "Redeem"
  Then I should be on the store page with promo code "WXYZ"
  And the "Discount Code" field should contain "WXYZ"
  And I should see "Special" within "#voucher_menus"

Scenario: discount tickets disappear if promo cleared

  When I fill in "Discount Code" with "wxyz"
  And I press "Redeem"
  Then I should be on the store page with promo code "WXYZ"
  When I fill in "Discount Code" with ""
  And I press "Redeem"
  Then I should be on the store page
  And I should not see "Special" within "#voucher_menus"
