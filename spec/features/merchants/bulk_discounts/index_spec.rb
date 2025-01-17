require 'rails_helper'

RSpec.describe 'bulk discount index page' do
  describe 'I see all of my bulk discounts' do
    it 'shows discounts & their info & links to show page' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      discount_1 = merchant_1.bulk_discounts.create!(name: "Bob's Special", qty_threshold: 10, pct_discount: 15)
      discount_2 = merchant_1.bulk_discounts.create!(name: "Heavy Metal", qty_threshold: 6, pct_discount: 10)
      discount_3 = merchant_1.bulk_discounts.create!(name: "Beeeeeeees?!!??!!", qty_threshold: 20, pct_discount: 40)

      visit merchant_bulk_discounts_path(merchant_1.id)

      within "#disc-#{discount_1.id}" do
        expect(page).to have_selector(:link_or_button, "Bob's Special Info.")
        expect(page).to have_content("Bob's Special - 15% Off for 10 Items!")
        expect(page).to_not have_content("Heavy Metal - 10% Off for 6 Items")
      end

      within "#disc-#{discount_2.id}" do
        expect(page).to have_selector(:link_or_button, "Heavy Metal Info.")
        expect(page).to have_content("Heavy Metal - 10% Off for 6 Items")
        expect(page).to_not have_content("Beeeeeeees?!!??!! - 40% off all insects in store")
      end

      within "#disc-#{discount_3.id}" do
        expect(page).to have_selector(:link_or_button, "Beeeeeeees?!!??!! Info.")
        expect(page).to have_content("Beeeeeeees?!!??!! - 40% Off for 20 Items!")
        expect(page).to_not have_content("Bob's Special - 15% Off 10 Items!")
      end

      click_on "Bob's Special Info."

      expect(page).to have_content("10 Items - Quantity Minimum for Discount")
      expect(page).to_not have_content("6 Items - Quantity Minimum for Discount")
    end
  end

  describe 'holiday API user story' do
    it 'shows the next three upcoming holidays' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      discount_1 = merchant_1.bulk_discounts.create!(name: "Bob's Special", qty_threshold: 10, pct_discount: 15)
      discount_2 = merchant_1.bulk_discounts.create!(name: "Heavy Metal", qty_threshold: 6, pct_discount: 10)
      discount_3 = merchant_1.bulk_discounts.create!(name: "Beeeeeeees?!!??!!", qty_threshold: 20, pct_discount: 40)

      visit merchant_bulk_discounts_path(merchant_1.id)

      expect(page).to have_content("Labour Day, 2022-09-05")
      expect(page).to have_content("Columbus Day, 2022-10-10")
      expect(page).to have_content("Veterans Day, 2022-11-11")
    end
  end
end