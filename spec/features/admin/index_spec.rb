require 'rails_helper'

RSpec.describe "admin dashboard" do
    it 'has an admin dashboard header ' do

      visit("/admin")

      expect(page).to have_content("Admin Dashboard")
    end

    it "has links to the merchants index and the invoices index" do

      visit("/admin")

      click_on("Merchants")
      expect(current_path).to eq("/admin/merchants")

      visit("/admin")

      click_on("Invoices")
      expect(current_path).to eq("/admin/invoices")
    end

    it "displays the top 5 customer with transacitons" do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 500, merchant_id: merchant_1.id )
      item_2 = Item.create!(name: "Saw", description: "Metal, sharp", unit_price: 700, merchant_id: merchant_1.id )
      item_3 = Item.create!(name: "Bench", description: "Cedar bench", unit_price: 900, merchant_id: merchant_1.id )
      item_4 = Item.create!(name: "Axe", description: "Big Axe", unit_price: 1000, merchant_id: merchant_1.id )
      item_5 = Item.create!(name: "Table Saw", description: "Steel, hand held", unit_price: 900, merchant_id: merchant_1.id )

      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")
      customer_2 = Customer.create!(first_name: "Cindy", last_name: "Lou")
      customer_3 = Customer.create!(first_name: "John", last_name: "Johnson")
      customer_4 = Customer.create!(first_name: "Mary", last_name: "Vale")
      customer_5 = Customer.create!(first_name: "Brian", last_name: "Long")
      customer_6 = Customer.create!(first_name: "Mark", last_name: "Dole")

      invoice_1 = Invoice.create!(status: 2, customer_id: customer_1.id)
      invoice_2 = Invoice.create!(status: 2, customer_id: customer_2.id)
      invoice_3 = Invoice.create!(status: 2, customer_id: customer_3.id)
      invoice_4 = Invoice.create!(status: 2, customer_id: customer_4.id)
      invoice_5 = Invoice.create!(status: 2, customer_id: customer_5.id)
      invoice_6 = Invoice.create!(status: 0, customer_id: customer_6.id)

      transaction_1 = Transaction.create!(result: 0, invoice_id: invoice_1.id, credit_card_number: "154897654")
      transaction_2 = Transaction.create!(result: 0, invoice_id: invoice_1.id, credit_card_number: "154897654")
      transaction_3 = Transaction.create!(result: 0, invoice_id: invoice_1.id, credit_card_number: "154897654")
      transaction_4 = Transaction.create!(result: 0, invoice_id: invoice_1.id, credit_card_number: "154897654")
      transaction_5 = Transaction.create!(result: 0, invoice_id: invoice_1.id, credit_card_number: "154897654")
      transaction_6 = Transaction.create!(result: 0, invoice_id: invoice_1.id, credit_card_number: "154897654")

      transaction_7 = Transaction.create!(result: 0, invoice_id: invoice_2.id, credit_card_number: "547896542")
      transaction_8 = Transaction.create!(result: 0, invoice_id: invoice_2.id, credit_card_number: "547896542")
      transaction_9 = Transaction.create!(result: 0, invoice_id: invoice_2.id, credit_card_number: "547896542")
      transaction_10 = Transaction.create!(result: 0, invoice_id: invoice_2.id, credit_card_number: "547896542")
      transaction_11 = Transaction.create!(result: 0, invoice_id: invoice_2.id, credit_card_number: "547896542")

      transaction_12 = Transaction.create!(result: 0, invoice_id: invoice_3.id, credit_card_number: "487956542")
      transaction_13 = Transaction.create!(result: 0, invoice_id: invoice_3.id, credit_card_number: "487956542")
      transaction_14 = Transaction.create!(result: 0, invoice_id: invoice_3.id, credit_card_number: "487956542")
      transaction_15 = Transaction.create!(result: 0, invoice_id: invoice_3.id, credit_card_number: "487956542")

      transaction_16 = Transaction.create!(result: 0, invoice_id: invoice_4.id, credit_card_number: "347895421")
      transaction_17 = Transaction.create!(result: 0, invoice_id: invoice_4.id, credit_card_number: "347895421")
      transaction_18 = Transaction.create!(result: 0, invoice_id: invoice_4.id, credit_card_number: "347895421")

      transaction_19 = Transaction.create!(result: 0, invoice_id: invoice_5.id, credit_card_number: "744589654")
      transaction_20 = Transaction.create!(result: 0, invoice_id: invoice_5.id, credit_card_number: "744589654")

      transaction_21 = Transaction.create!(result: 0, invoice_id: invoice_6.id, credit_card_number: "347895454")
      transaction_22 = Transaction.create!(result: 1, invoice_id: invoice_6.id, credit_card_number: "347895454")

      invoice_item_1 = InvoiceItem.create!(quantity: 4, unit_price: 800, status: 2, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 2, unit_price: 1400, status: 2, item_id: item_2.id, invoice_id: invoice_2.id)
      invoice_item_3 = InvoiceItem.create!(quantity: 3, unit_price: 666, status: 2, item_id: item_3.id, invoice_id: invoice_3.id)
      invoice_item_4 = InvoiceItem.create!(quantity: 2, unit_price: 1400, status: 2, item_id: item_4.id, invoice_id: invoice_4.id)
      invoice_item_5 = InvoiceItem.create!(quantity: 3, unit_price: 666, status: 2, item_id: item_5.id, invoice_id: invoice_5.id)
      invoice_item_6 = InvoiceItem.create!(quantity: 3, unit_price: 666, status: 2, item_id: item_5.id, invoice_id: invoice_6.id)

      visit("/admin")

      within '#customer0' do
          expect(page).to have_content("David Smith")
          expect(page).to_not have_content("Cindy Lou")
          expect(page).to have_content("6 Purchases")
          expect(page).to_not have_content("5 Purchases")
      end

      within '#customer1' do
        expect(page).to have_content("Cindy Lou")
        expect(page).to_not have_content("David Smith")
        expect(page).to have_content("5 Purchases")
        expect(page).to_not have_content("4 Purchases")
      end

      within '#customer2' do
        expect(page).to have_content("John Johnson")
        expect(page).to_not have_content("Cindy Lou")
        expect(page).to have_content("4 Purchases")
        expect(page).to_not have_content("3 Purchases")
      end

      within '#customer3' do
        expect(page).to have_content("Mary Vale")
        expect(page).to_not have_content("Cindy Lou")
        expect(page).to have_content("3 Purchases")
        expect(page).to_not have_content("2 Purchases")
      end

      within '#customer4' do
        expect(page).to have_content("Brian Long")
        expect(page).to_not have_content("Cindy Lou")
        expect(page).to have_content("2 Purchases")
        expect(page).to_not have_content("3 Purchases")
      end
    end

end
