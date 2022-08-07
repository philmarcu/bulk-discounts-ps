require 'rails_helper'

RSpec.describe 'discounts edit / update' do
  context 'edit feature' do
    it 'takes us to a edit page' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      discount_1 = merchant_1.bulk_discounts.create!(name: "Bob's Special", qty_threshold: 10, pct_discount: 15)

      visit "/merchants/#{merchant_1.id}/bulk_discounts/#{discount_1.id}/edit"

      expect(page).to have_content("Edit Bob's Special")
      expect(page).to have_field('Discount Name', with: "Bob's Special")
      expect(page).to have_field('Quantity Threshold', with: 10)
      expect(page).to have_field('Discount Percentage', with: 15)
    end
  end

  context 'update action' do
    it 'updates the discounts info with new info' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      discount_1 = merchant_1.bulk_discounts.create!(name: "Bob's Special", qty_threshold: 10, pct_discount: 15)

      visit "/merchants/#{merchant_1.id}/bulk_discounts/#{discount_1.id}/edit"

      fill_in "Discount Name", with: "Bob's SUPERRR SPECIAL"
      fill_in "Quantity Threshold", with: 20
      fill_in "Discount Percentage", with: 30
      click_on "Submit"

      expect(page).to have_current_path("/merchants/#{merchant_1.id}/bulk_discounts/#{discount_1.id}")
      expect(page).to have_content("Bob's SUPERRR SPECIAL - Discount for Bobs Loggers")
      expect(page).to have_content("20 Items")
      expect(page).to have_content("30% - Percentage Off")
    end

    it 'redirects to edit if data is not valid (name excluded)' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      discount_1 = merchant_1.bulk_discounts.create!(name: "Bob's Special", qty_threshold: 10, pct_discount: 15)

      visit "/merchants/#{merchant_1.id}/bulk_discounts/#{discount_1.id}/edit"

      fill_in "Discount Name", with: " "
      fill_in "Quantity Threshold", with: " "
      fill_in "Discount Percentage", with: " "
      click_on "Submit"

      expect(page).to have_current_path("/merchants/#{merchant_1.id}/bulk_discounts/#{discount_1.id}/edit")
      expect(page).to have_content("Error: Qty threshold can't be blank, Qty threshold is not a number")
      expect(page).to have_content("Pct discount can't be blank, Pct discount is not a number")
    end
  end
end

# Merchant Bulk Discount Edit

# As a merchant
# When I visit my bulk discount show page
# Then I see a link to edit the bulk discount
# When I click this link
# Then I am taken to a new page with a form to edit the discount
# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated