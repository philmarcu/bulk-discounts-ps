require 'rails_helper'

RSpec.describe "merchants invoice show page" do
  describe '#show' do
    it 'when I visit a merchant invoice show page I do not see any information from other merchants' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")
      merchant_2 = Merchant.create!(name: "Funny Shirts")

      item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 500, merchant_id: merchant_1.id )
      item_2 = Item.create!(name: "Saw", description: "Metal, sharp", unit_price: 700, merchant_id: merchant_1.id )
      item_3 = Item.create!(name: "Shirt", description: "Cotton", unit_price: 100, merchant_id: merchant_2.id )

      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")
      customer_2 = Customer.create!(first_name: "Cindy", last_name: "Lou")

      invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id)
      invoice_2 = Invoice.create!(status: 0, customer_id: customer_2.id)

      invoice_item_1 = InvoiceItem.create!(quantity: 4, unit_price: 800, status: 0, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 2, unit_price: 1400, status: 0, item_id: item_2.id, invoice_id: invoice_1.id)
      invoice_item_3 = InvoiceItem.create!(quantity: 3, unit_price: 666, status: 0, item_id: item_3.id, invoice_id: invoice_2.id)

      visit "/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}"

      expect(page).to have_content("Item: Log")
      expect(page).to have_content("Item: Saw")
      expect(page).to_not have_content("Item: Shirt")
    end

    it 'shows invoice id/invoice status/invoice created_at/customer name' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 500, merchant_id: merchant_1.id )
      item_2 = Item.create!(name: "Saw", description: "Metal, sharp", unit_price: 700, merchant_id: merchant_1.id )
      item_3 = Item.create!(name: "Bench", description: "Cedar bench", unit_price: 900, merchant_id: merchant_1.id )

      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")

      invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id)
      invoice_2 = Invoice.create!(status: 0, customer_id: customer_1.id)
      invoice_3 = Invoice.create!(status: 0, customer_id: customer_1.id)

      invoice_item_1 = InvoiceItem.create!(quantity: 4, unit_price: 800, status: 0, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 2, unit_price: 1400, status: 0, item_id: item_2.id, invoice_id: invoice_2.id)
      invoice_item_3 = InvoiceItem.create!(quantity: 3, unit_price: 666, status: 0, item_id: item_3.id, invoice_id: invoice_3.id)

      visit "/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}"

      expect(page).to have_content(invoice_1.id)
      expect(page).to have_content(invoice_1.status)
      expect(page).to have_content(invoice_1.created_at.strftime("%A, %B%e, %Y"))
      expect(page).to have_content("David Smith")
    end

    it 'shows all item names' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 500, merchant_id: merchant_1.id )
      item_2 = Item.create!(name: "Saw", description: "Metal, sharp", unit_price: 700, merchant_id: merchant_1.id )
      item_3 = Item.create!(name: "Bench", description: "Cedar bench", unit_price: 900, merchant_id: merchant_1.id )

      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")

      invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id)

      invoice_item_1 = InvoiceItem.create!(quantity: 4, unit_price: 800, status: 0, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 2, unit_price: 1400, status: 0, item_id: item_2.id, invoice_id: invoice_1.id)
      invoice_item_3 = InvoiceItem.create!(quantity: 3, unit_price: 500, status: 0, item_id: item_3.id, invoice_id: invoice_1.id)

      visit "/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}"

      within "#items-#{item_1.id}" do
        expect(page).to have_content("Log")
        expect(page).to_not have_content("Saw")
      end

      within "#items-#{item_2.id}" do
        expect(page).to have_content("Saw")
        expect(page).to_not have_content("Log")
      end

      within "#items-#{item_3.id}" do
        expect(page).to have_content("Bench")
        expect(page).to_not have_content("Log")
      end
    end

    it 'shows the quantity of the item ordered' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 500, merchant_id: merchant_1.id )
      item_2 = Item.create!(name: "Saw", description: "Metal, sharp", unit_price: 700, merchant_id: merchant_1.id )
      item_3 = Item.create!(name: "Bench", description: "Cedar bench", unit_price: 900, merchant_id: merchant_1.id )

      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")

      invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id)

      invoice_item_1 = InvoiceItem.create!(quantity: 4, unit_price: 800, status: 0, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 2, unit_price: 1400, status: 0, item_id: item_2.id, invoice_id: invoice_1.id)
      invoice_item_3 = InvoiceItem.create!(quantity: 3, unit_price: 500, status: 0, item_id: item_3.id, invoice_id: invoice_1.id)

      visit "/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}"

      within "#items-#{item_1.id}" do
        expect(page).to have_content("Quantity: 4")
        expect(page).to_not have_content("Quantity: 2")
      end

      within "#items-#{item_2.id}" do
        expect(page).to have_content("Quantity: 2")
        expect(page).to_not have_content("Quantity: 3")
      end

      within "#items-#{item_3.id}" do
        expect(page).to have_content("Quantity: 3")
        expect(page).to_not have_content("Quantity: 4")
      end
    end

    it 'shows the price of the ordered invoice items' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 500, merchant_id: merchant_1.id )
      item_2 = Item.create!(name: "Saw", description: "Metal, sharp", unit_price: 700, merchant_id: merchant_1.id )
      item_3 = Item.create!(name: "Bench", description: "Cedar bench", unit_price: 200, merchant_id: merchant_1.id )

      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")

      invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id)

      invoice_item_1 = InvoiceItem.create!(quantity: 4, unit_price: 2000, status: 0, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 2, unit_price: 1400, status: 1, item_id: item_2.id, invoice_id: invoice_1.id)
      invoice_item_3 = InvoiceItem.create!(quantity: 3, unit_price: 600, status: 2, item_id: item_3.id, invoice_id: invoice_1.id)

      visit "/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}"

      within "#items-#{item_1.id}" do
        expect(page).to have_content("Price: $20.00")
        expect(page).to_not have_content("Price: $14.00")
      end

      within "#items-#{item_2.id}" do
        expect(page).to have_content("Price: $14.00")
        expect(page).to_not have_content("Price: $20.00")
      end

      within "#items-#{item_3.id}" do
        expect(page).to have_content("Price: $6.00")
        expect(page).to_not have_content("Price: $20.00")
      end
    end

    it 'shows the status of the ordered invoice items' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 500, merchant_id: merchant_1.id )
      item_2 = Item.create!(name: "Saw", description: "Metal, sharp", unit_price: 700, merchant_id: merchant_1.id )
      item_3 = Item.create!(name: "Bench", description: "Cedar bench", unit_price: 200, merchant_id: merchant_1.id )

      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")

      invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id)

      invoice_item_1 = InvoiceItem.create!(quantity: 4, unit_price: 2000, status: 0, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 2, unit_price: 1400, status: 1, item_id: item_2.id, invoice_id: invoice_1.id)
      invoice_item_3 = InvoiceItem.create!(quantity: 3, unit_price: 600, status: 2, item_id: item_3.id, invoice_id: invoice_1.id)

      visit "/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}"

      within "#items-#{item_1.id}" do
        expect(page).to have_select(:update_status, selected: "pending")
        expect(page).to_not have_select(:update_status, selected: "packaged")
      end

      within "#items-#{item_2.id}" do
        expect(page).to have_select(:update_status, selected: "packaged")
        expect(page).to_not have_select(:update_status, selected: "pending")
      end

      within "#items-#{item_3.id}" do
        expect(page).to have_select(:update_status, selected: "shipped")
        expect(page).to_not have_select(:update_status, selected: "pending")
      end
    end

    it 'update invoice item status' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")
      item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 500, merchant_id: merchant_1.id )
      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")
      invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id)
      invoice_item_1 = InvoiceItem.create!(quantity: 4, unit_price: 2000, status: 0, item_id: item_1.id, invoice_id: invoice_1.id)

      visit "/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}"

      within "#items-#{item_1.id}" do
        expect(page).to have_select(:update_status, selected: "pending")
        select 'packaged', :from => :update_status
        click_on "Update Status"
        expect(current_path).to eq("/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}")
      end

      within "#items-#{item_1.id}" do
        expect(page).to have_select(:update_status, selected: "packaged")
      end
    end

    it 'shows the total revenue that will be generated from all items on the invoice' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 500, merchant_id: merchant_1.id )
      item_2 = Item.create!(name: "Saw", description: "Metal, sharp", unit_price: 700, merchant_id: merchant_1.id )
      item_3 = Item.create!(name: "Bench", description: "Cedar bench", unit_price: 900, merchant_id: merchant_1.id )

      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")

      invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id)
      invoice_2 = Invoice.create!(status: 0, customer_id: customer_1.id)
      invoice_3 = Invoice.create!(status: 0, customer_id: customer_1.id)

      invoice_item_1 = InvoiceItem.create!(quantity: 4, unit_price: 100, status: 0, item_id: item_1.id, invoice_id: invoice_3.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 2, unit_price: 1400, status: 0, item_id: item_2.id, invoice_id: invoice_2.id)
      invoice_item_3 = InvoiceItem.create!(quantity: 3, unit_price: 150, status: 0, item_id: item_3.id, invoice_id: invoice_3.id)

      visit "/merchants/#{merchant_1.id}/invoices/#{invoice_3.id}"

      expect(page).to have_content("Total Revenue: $8.50")
    end

    it 'shows the discounted revenue' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 500, merchant_id: merchant_1.id )
      item_2 = Item.create!(name: "Saw", description: "Metal, sharp", unit_price: 700, merchant_id: merchant_1.id )
      item_3 = Item.create!(name: "Bench", description: "Cedar bench", unit_price: 900, merchant_id: merchant_1.id )
      item_4 = Item.create!(name: "Axe", description: "Big Axe", unit_price: 500, merchant_id: merchant_1.id )
      item_5 = Item.create!(name: "Hammer", description: "Carpenter's hammer, wood handle", unit_price: 600, merchant_id: merchant_1.id )
      item_6 = Item.create!(name: "Speed Square", description: "Metal w/ level", unit_price: 700, merchant_id: merchant_1.id )

      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")

      invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id)
      invoice_2 = Invoice.create!(status: 0, customer_id: customer_1.id)
      invoice_3 = Invoice.create!(status: 0, customer_id: customer_1.id)

      invoice_item_1 = InvoiceItem.create!(quantity: 4, unit_price: 500, status: 0, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 15, unit_price: 700, status: 0, item_id: item_2.id, invoice_id: invoice_1.id)
      invoice_item_3 = InvoiceItem.create!(quantity: 3, unit_price: 150, status: 0, item_id: item_3.id, invoice_id: invoice_2.id)
      invoice_item_4 = InvoiceItem.create!(quantity: 11, unit_price: 500, status: 1, item_id: item_4.id, invoice_id: invoice_2.id)
      invoice_item_5 = InvoiceItem.create!(quantity: 3, unit_price: 600, status: 2, item_id: item_5.id, invoice_id: invoice_3.id)
      invoice_item_6 = InvoiceItem.create!(quantity: 5, unit_price: 700, status: 0, item_id: item_6.id, invoice_id: invoice_3.id)

      discount_1 = merchant_1.bulk_discounts.create!(name: "November Deal - Black Thursday!", qty_threshold: 10, pct_discount: 12)
      discount_2 = merchant_1.bulk_discounts.create!(name: "Crazy Fall Sale", qty_threshold: 15, pct_discount: 25)

      visit "/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}"
      
      expect(page).to have_content("Total Revenue: $125.00")
      expect(page).to have_content("Discounted Revenue: $98.75")

      visit "/merchants/#{merchant_1.id}/invoices/#{invoice_2.id}"

      expect(page).to have_content("Total Revenue: $59.50")
      expect(page).to have_content("Discounted Revenue: $52.90")

      visit "/merchants/#{merchant_1.id}/invoices/#{invoice_3.id}"

      expect(page).to have_content("Total Revenue: $53.00")
      expect(page).to have_content("Discounted Revenue: N/A")
    end

    it 'links to bulk discount page if discount was applied' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 500, merchant_id: merchant_1.id )
      item_2 = Item.create!(name: "Saw", description: "Metal, sharp", unit_price: 700, merchant_id: merchant_1.id )
      item_3 = Item.create!(name: "Bench", description: "Cedar bench", unit_price: 900, merchant_id: merchant_1.id )
      item_4 = Item.create!(name: "Axe", description: "Big Axe", unit_price: 500, merchant_id: merchant_1.id )

      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")

      invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id)
      invoice_2 = Invoice.create!(status: 0, customer_id: customer_1.id)

      invoice_item_1 = InvoiceItem.create!(quantity: 14, unit_price: 500, status: 0, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 15, unit_price: 700, status: 0, item_id: item_2.id, invoice_id: invoice_1.id)
      invoice_item_3 = InvoiceItem.create!(quantity: 3, unit_price: 150, status: 0, item_id: item_3.id, invoice_id: invoice_2.id)
      invoice_item_4 = InvoiceItem.create!(quantity: 11, unit_price: 500, status: 1, item_id: item_4.id, invoice_id: invoice_2.id)
      invoice_item_5 = InvoiceItem.create!(quantity: 3, unit_price: 600, status: 2, item_id: item_5.id, invoice_id: invoice_3.id)
      invoice_item_6 = InvoiceItem.create!(quantity: 5, unit_price: 700, status: 0, item_id: item_6.id, invoice_id: invoice_3.id)

      discount_1 = merchant_1.bulk_discounts.create!(name: "November Deal - Black Thursday!", qty_threshold: 10, pct_discount: 12)
      discount_2 = merchant_1.bulk_discounts.create!(name: "Crazy Fall Sale", qty_threshold: 15, pct_discount: 25)

      visit "/merchants/#{merchant_1.id}/invoices/#{invoice_1.id}"
      
      within "#disc-#{invoice_item_1.id}" do
        expect(page).to have_selector(:link_or_button, "November Deal - Black Thursday! Discount")
        expect(page).to_not have_selector(:link_or_button, "Crazy Fall Sale Discount")
      end

      within "#disc-#{invoice_item_2.id}" do
        expect(page).to have_selector(:link_or_button, "Crazy Fall Sale Discount")
        expect(page).to have_selector(:link_or_button, "November Deal - Black Thursday! Discount")
      end

      visit "/merchants/#{merchant_1.id}/invoices/#{invoice_2.id}"

      within "#disc-#{invoice_item_3.id}" do
        expect(page).to_not have_selector(:link_or_button, "Crazy Fall Sale Discount")
        expect(page).to_not have_selector(:link_or_button, "November Deal - Black Thursday! Discount")
      end

      within "#disc-#{invoice_item_4.id}" do
        expect(page).to have_selector(:link_or_button, "November Deal - Black Thursday! Discount")
        expect(page).to_not have_selector(:link_or_button, "Crazy Fall Sale Discount")
      end
    end
  end

end
