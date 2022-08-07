require 'rails_helper'

RSpec.describe 'bulk discounts new / create' do
  describe 'bulk discount new page' do
    it 'renders the new form' do
      merchant_1 = Merchant.create!(name: 'Spongebob The Merchant')

      visit "/merchants/#{merchant_1.id}/items/new"

      expect(page).to have_content('New Item')
      expect(find('form')).to have_content('Name')
      expect(find('form')).to have_content('Quantity Threshold')
      expect(find('form')).to have_content('Discount Percentage')
  end

    it 'creates bulk discount & goes to index page' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      visit "/merchants/#{merchant_1.id}/bulk_discounts/new"

      fill_in('Name', with: 'Super Saleeee!')
      fill_in('Quantity Threshold', with: 12)
      fill_in('Discount Percentage', with: 35)
      click_on "Create"

      expect(page).to have_current_path("/merchants/#{merchant_1.id}/bulk_discounts")
      expect(page).to have_content("Current Offer: Super Saleeee!")
    end
  end
end