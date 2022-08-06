require 'rails_helper'

RSpec.describe 'bulk discount index page' do
  describe 'I see all of my bulk discounts' do
    it 'shows discounts & their info' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      discount_1 = merchant_1.bulk_discounts.create!(name: "Bob's Special", qty_threshold: 10, pct_discount: 15)
      discount_2 = merchant_1.bulk_discounts.create!(name: "Heavy Metal", qty_threshold: 6, pct_discount: 10)
      discount_3 = merchant_1.bulk_discounts.create!(name: "Beeeeeeees?!!??!!", qty_threshold: 20, pct_discount: 40)

      visit "/merchants/#{merchant_1.id}/bulk_discounts"

      within "#disc-#{discount_1.id}" do
        expect(page).to have_content("Bob's Special - 15% Off for 10 Items!")
        expect(page).to_not have_content("Heavy Metal - 10% Off for 6 Items")
      end

      within "#disc-#{discount_2.id}" do
        expect(page).to have_content("Heavy Metal - 10% Off for 6 Items")
        expect(page).to_not have_content("Beeeeeeees?!!??!! - 40% off all insects in store")
      end

      within "#disc-#{discount_3.id}" do
        expect(page).to have_content("Beeeeeeees?!!??!! - 40% Off for 20 Items!")
        expect(page).to_not have_content("Bob's Special - 15% Off 10 Items!")
      end
    end
  end
end

# Merchant Bulk Discounts Index

# As a merchant
# When I visit my merchant dashboard
# Then I see a link to view all my discounts
# When I click this link
# Then I am taken to my bulk discounts index page
# Where I see all of my bulk discounts including their
# percentage discount and quantity thresholds
# And each bulk discount listed includes a link to its show page