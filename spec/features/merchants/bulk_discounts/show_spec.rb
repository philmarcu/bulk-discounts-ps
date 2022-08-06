require 'rails_helper'

RSpec.describe 'bulk discounts show page' do
  it 'shows me a specific discounts qty threshold & pct discount' do
    merchant_1 = Merchant.create!(name: "Bobs Loggers")

    discount_1 = merchant_1.bulk_discounts.create!(name: "Bob's Special", qty_threshold: 10, pct_discount: 15)
    discount_2 = merchant_1.bulk_discounts.create!(name: "Heavy Metal", qty_threshold: 6, pct_discount: 10)

    visit "merchants/#{merchant_1.id}/bulk_discounts/#{discount_1.id}"

    expect(page).to have_content("Bob's Special")
    expect(page).to have_content("10 Items - Quantity Minimum for Discount")
    expect(page).to have_content("15% - Percentage Off") 
    expect(page).to_not have_content("Heavy Metal")
    expect(page).to_not have_content("6 Items - Quantity Minimum for Discount")
    expect(page).to_not have_content("10% - Percentage Off")
  end
end