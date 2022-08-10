require 'rails_helper'

RSpec.describe Invoice do
  describe 'validations' do
    it { should validate_presence_of(:status) }
  end

  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:bulk_discounts).through(:merchants) }
  end

  describe 'model methods' do
    it "#total_revenue" do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")
      merchant_2 = Merchant.create!(name: "Roberts Loggings")
      item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 200, merchant_id: merchant_1.id )
      item_2 = Item.create!(name: "Saw", description: "Metal, sharp", unit_price: 300, merchant_id: merchant_1.id )
      item_3 = Item.create!(name: "Bench", description: "Cedar bench", unit_price: 400, merchant_id: merchant_1.id )
      item_4 = Item.create!(name: "Axe", description: "Big Axe", unit_price: 500, merchant_id: merchant_1.id )
      item_5 = Item.create!(name: "Hammer", description: "Carpenter's hammer, wood handle", unit_price: 600, merchant_id: merchant_2.id )
      item_6 = Item.create!(name: "Speed Square", description: "Metal w/ level", unit_price: 700, merchant_id: merchant_2.id )
      item_7 = Item.create!(name: "Mallet", description: "Wooden carpenter's mallet", unit_price: 800, merchant_id: merchant_2.id )
      item_8 = Item.create!(name: "Reciprocating Saw", description: "Electric reciprocating saw", unit_price: 900, merchant_id: merchant_2.id )

      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")
      customer_2 = Customer.create!(first_name: "Cindy", last_name: "Lou")
      customer_3 = Customer.create!(first_name: "John", last_name: "Johnson")
      customer_4 = Customer.create!(first_name: "Mary", last_name: "Vale")

      invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id)
      invoice_2 = Invoice.create!(status: 0, customer_id: customer_2.id)
      invoice_3 = Invoice.create!(status: 2, customer_id: customer_3.id)
      invoice_4 = Invoice.create!(status: 2, customer_id: customer_4.id)
      invoice_5 = Invoice.create!(status: 0, customer_id: customer_4.id)

      invoice_item_1 = InvoiceItem.create!(quantity: 4, unit_price: 200, status: 0, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 2, unit_price: 300, status: 1, item_id: item_2.id, invoice_id: invoice_1.id)
      invoice_item_3 = InvoiceItem.create!(quantity: 3, unit_price: 400, status: 2, item_id: item_3.id, invoice_id: invoice_2.id)
      invoice_item_4 = InvoiceItem.create!(quantity: 2, unit_price: 500, status: 1, item_id: item_4.id, invoice_id: invoice_2.id)
      invoice_item_5 = InvoiceItem.create!(quantity: 3, unit_price: 600, status: 2, item_id: item_5.id, invoice_id: invoice_3.id)
      invoice_item_6 = InvoiceItem.create!(quantity: 3, unit_price: 700, status: 0, item_id: item_6.id, invoice_id: invoice_3.id)
      invoice_item_7 = InvoiceItem.create!(quantity: 3, unit_price: 800, status: 2, item_id: item_7.id, invoice_id: invoice_4.id)
      invoice_item_8 = InvoiceItem.create!(quantity: 3, unit_price: 900, status: 2, item_id: item_8.id, invoice_id: invoice_4.id)
      invoice_item_9 = InvoiceItem.create!(quantity: 3, unit_price: 900, status: 1, item_id: item_8.id, invoice_id: invoice_5.id)
      invoice_item_10 = InvoiceItem.create!(quantity: 3, unit_price: 900, status: 1, item_id: item_8.id, invoice_id: invoice_5.id)

      expect(invoice_1.total_revenue).to eq(1400)
      expect(invoice_2.total_revenue).to eq(2200)
    end

    it "#incomplete_invoices" do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")
      merchant_2 = Merchant.create!(name: "Roberts Loggings")
      item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 200, merchant_id: merchant_1.id )
      item_2 = Item.create!(name: "Saw", description: "Metal, sharp", unit_price: 300, merchant_id: merchant_1.id )
      item_3 = Item.create!(name: "Bench", description: "Cedar bench", unit_price: 400, merchant_id: merchant_1.id )
      item_4 = Item.create!(name: "Axe", description: "Big Axe", unit_price: 500, merchant_id: merchant_1.id )
      item_5 = Item.create!(name: "Hammer", description: "Carpenter's hammer, wood handle", unit_price: 600, merchant_id: merchant_2.id )
      item_6 = Item.create!(name: "Speed Square", description: "Metal w/ level", unit_price: 700, merchant_id: merchant_2.id )
      item_7 = Item.create!(name: "Mallet", description: "Wooden carpenter's mallet", unit_price: 800, merchant_id: merchant_2.id )
      item_8 = Item.create!(name: "Reciprocating Saw", description: "Electric reciprocating saw", unit_price: 900, merchant_id: merchant_2.id )

      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")
      customer_2 = Customer.create!(first_name: "Cindy", last_name: "Lou")
      customer_3 = Customer.create!(first_name: "John", last_name: "Johnson")
      customer_4 = Customer.create!(first_name: "Mary", last_name: "Vale")

      invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id)
      invoice_2 = Invoice.create!(status: 0, customer_id: customer_2.id)
      invoice_3 = Invoice.create!(status: 2, customer_id: customer_3.id)
      invoice_4 = Invoice.create!(status: 2, customer_id: customer_4.id)
      invoice_5 = Invoice.create!(status: 0, customer_id: customer_4.id)

      invoice_item_1 = InvoiceItem.create!(quantity: 4, unit_price: 200, status: 0, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 2, unit_price: 300, status: 1, item_id: item_2.id, invoice_id: invoice_1.id)
      invoice_item_3 = InvoiceItem.create!(quantity: 3, unit_price: 400, status: 2, item_id: item_3.id, invoice_id: invoice_2.id)
      invoice_item_4 = InvoiceItem.create!(quantity: 2, unit_price: 500, status: 1, item_id: item_4.id, invoice_id: invoice_2.id)
      invoice_item_5 = InvoiceItem.create!(quantity: 3, unit_price: 600, status: 2, item_id: item_5.id, invoice_id: invoice_3.id)
      invoice_item_6 = InvoiceItem.create!(quantity: 3, unit_price: 700, status: 0, item_id: item_6.id, invoice_id: invoice_3.id)
      invoice_item_7 = InvoiceItem.create!(quantity: 3, unit_price: 800, status: 2, item_id: item_7.id, invoice_id: invoice_4.id)
      invoice_item_8 = InvoiceItem.create!(quantity: 3, unit_price: 900, status: 2, item_id: item_8.id, invoice_id: invoice_4.id)
      invoice_item_9 = InvoiceItem.create!(quantity: 3, unit_price: 900, status: 1, item_id: item_8.id, invoice_id: invoice_5.id)
      invoice_item_10 = InvoiceItem.create!(quantity: 3, unit_price: 900, status: 1, item_id: item_8.id, invoice_id: invoice_5.id)

      expect(Invoice.incomplete_invoices.count).to eq(4)
      expect(Invoice.incomplete_invoices).to eq([invoice_1, invoice_2, invoice_3, invoice_5])
    end

    it '#discount_items' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 200, merchant_id: merchant_1.id )
      item_2 = Item.create!(name: "Saw", description: "Metal, sharp", unit_price: 300, merchant_id: merchant_1.id )
      item_3 = Item.create!(name: "Bench", description: "Cedar bench", unit_price: 400, merchant_id: merchant_1.id )
      item_4 = Item.create!(name: "Axe", description: "Big Axe", unit_price: 500, merchant_id: merchant_1.id )
      item_5 = Item.create!(name: "Hammer", description: "Carpenter's hammer, wood handle", unit_price: 600, merchant_id: merchant_1.id )
      item_6 = Item.create!(name: "Speed Square", description: "Metal w/ level", unit_price: 700, merchant_id: merchant_1.id )
      item_7 = Item.create!(name: "Mallet", description: "Wooden carpenter's mallet", unit_price: 800, merchant_id: merchant_1.id )
      item_8 = Item.create!(name: "Reciprocating Saw", description: "Electric reciprocating saw", unit_price: 900, merchant_id: merchant_1.id )

      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")
      customer_2 = Customer.create!(first_name: "Cindy", last_name: "Lou")
      customer_3 = Customer.create!(first_name: "John", last_name: "Johnson")
      customer_4 = Customer.create!(first_name: "Mary", last_name: "Vale")

      invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id)
      invoice_2 = Invoice.create!(status: 0, customer_id: customer_2.id)
      invoice_3 = Invoice.create!(status: 2, customer_id: customer_3.id)
      invoice_4 = Invoice.create!(status: 2, customer_id: customer_4.id)
      invoice_5 = Invoice.create!(status: 0, customer_id: customer_4.id)

      invoice_item_1 = InvoiceItem.create!(quantity: 15, unit_price: 200, status: 0, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 2, unit_price: 300, status: 1, item_id: item_2.id, invoice_id: invoice_1.id)
      invoice_item_3 = InvoiceItem.create!(quantity: 10, unit_price: 400, status: 2, item_id: item_3.id, invoice_id: invoice_2.id)
      invoice_item_4 = InvoiceItem.create!(quantity: 11, unit_price: 500, status: 1, item_id: item_4.id, invoice_id: invoice_2.id)
      invoice_item_5 = InvoiceItem.create!(quantity: 3, unit_price: 600, status: 2, item_id: item_5.id, invoice_id: invoice_3.id)
      invoice_item_6 = InvoiceItem.create!(quantity: 8, unit_price: 700, status: 0, item_id: item_6.id, invoice_id: invoice_3.id)
      invoice_item_7 = InvoiceItem.create!(quantity: 3, unit_price: 800, status: 2, item_id: item_7.id, invoice_id: invoice_4.id)
      invoice_item_8 = InvoiceItem.create!(quantity: 4, unit_price: 900, status: 2, item_id: item_8.id, invoice_id: invoice_4.id)
      invoice_item_9 = InvoiceItem.create!(quantity: 16, unit_price: 900, status: 1, item_id: item_8.id, invoice_id: invoice_5.id)
      invoice_item_10 = InvoiceItem.create!(quantity: 12, unit_price: 600, status: 1, item_id: item_5.id, invoice_id: invoice_5.id)
      invoice_item_11 = InvoiceItem.create!(quantity: 3, unit_price: 500, status: 1, item_id: item_4.id, invoice_id: invoice_5.id)

      discount_1 = merchant_1.bulk_discounts.create!(name: "November Deal - Black Thursday!", qty_threshold: 10, pct_discount: 12)
      discount_2 = merchant_1.bulk_discounts.create!(name: "Crazy Fall Sale", qty_threshold: 15, pct_discount: 25)
      discount_3 = merchant_1.bulk_discounts.create!(name: "Mellow Deals", qty_threshold: 5, pct_discount: 10)

      expect(invoice_1.discount_items).to eq([invoice_item_1])
      expect(invoice_2.discount_items).to eq([invoice_item_4, invoice_item_3])
      expect(invoice_3.discount_items).to eq([invoice_item_6])
      expect(invoice_4.discount_items).to eq([])
      expect(invoice_5.discount_items).to eq([invoice_item_9, invoice_item_10])
    end

    it '#disc_amount' do
      merchant_1 = Merchant.create!(name: "Bobs Loggers")

      item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 200, merchant_id: merchant_1.id )
      item_2 = Item.create!(name: "Saw", description: "Metal, sharp", unit_price: 300, merchant_id: merchant_1.id )
      item_3 = Item.create!(name: "Bench", description: "Cedar bench", unit_price: 400, merchant_id: merchant_1.id )
      item_4 = Item.create!(name: "Axe", description: "Big Axe", unit_price: 500, merchant_id: merchant_1.id )
      item_5 = Item.create!(name: "Hammer", description: "Carpenter's hammer, wood handle", unit_price: 600, merchant_id: merchant_1.id )
      item_6 = Item.create!(name: "Speed Square", description: "Metal w/ level", unit_price: 700, merchant_id: merchant_1.id )
      item_7 = Item.create!(name: "Mallet", description: "Wooden carpenter's mallet", unit_price: 800, merchant_id: merchant_1.id )
      item_8 = Item.create!(name: "Reciprocating Saw", description: "Electric reciprocating saw", unit_price: 900, merchant_id: merchant_1.id )

      customer_1 = Customer.create!(first_name: "David", last_name: "Smith")
      customer_2 = Customer.create!(first_name: "Cindy", last_name: "Lou")
      customer_3 = Customer.create!(first_name: "John", last_name: "Johnson")
      customer_4 = Customer.create!(first_name: "Mary", last_name: "Vale")

      invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id)
      invoice_2 = Invoice.create!(status: 0, customer_id: customer_2.id)
      invoice_3 = Invoice.create!(status: 2, customer_id: customer_3.id)
      invoice_4 = Invoice.create!(status: 2, customer_id: customer_4.id)
      invoice_5 = Invoice.create!(status: 0, customer_id: customer_4.id)
      invoice_6 = Invoice.create!(status: 0, customer_id: customer_4.id)

      invoice_item_1 = InvoiceItem.create!(quantity: 15, unit_price: 200, status: 0, item_id: item_1.id, invoice_id: invoice_1.id)
      invoice_item_2 = InvoiceItem.create!(quantity: 2, unit_price: 300, status: 1, item_id: item_2.id, invoice_id: invoice_1.id)
      invoice_item_3 = InvoiceItem.create!(quantity: 10, unit_price: 400, status: 2, item_id: item_3.id, invoice_id: invoice_2.id)
      invoice_item_4 = InvoiceItem.create!(quantity: 11, unit_price: 500, status: 1, item_id: item_4.id, invoice_id: invoice_2.id)
      invoice_item_5 = InvoiceItem.create!(quantity: 3, unit_price: 600, status: 2, item_id: item_5.id, invoice_id: invoice_3.id)
      invoice_item_6 = InvoiceItem.create!(quantity: 2, unit_price: 700, status: 0, item_id: item_6.id, invoice_id: invoice_3.id)
      invoice_item_7 = InvoiceItem.create!(quantity: 3, unit_price: 800, status: 2, item_id: item_7.id, invoice_id: invoice_4.id)
      invoice_item_8 = InvoiceItem.create!(quantity: 6, unit_price: 900, status: 2, item_id: item_8.id, invoice_id: invoice_4.id)
      invoice_item_9 = InvoiceItem.create!(quantity: 16, unit_price: 900, status: 1, item_id: item_8.id, invoice_id: invoice_5.id)
      invoice_item_10 = InvoiceItem.create!(quantity: 12, unit_price: 600, status: 1, item_id: item_5.id, invoice_id: invoice_5.id)
      invoice_item_11 = InvoiceItem.create!(quantity: 3, unit_price: 500, status: 1, item_id: item_4.id, invoice_id: invoice_5.id)
      invoice_item_12 = InvoiceItem.create!(quantity: 4, unit_price: 500, status: 1, item_id: item_1.id, invoice_id: invoice_6.id)

      discount_1 = merchant_1.bulk_discounts.create!(name: "November Deal - Black Thursday!", qty_threshold: 10, pct_discount: 12)
      discount_2 = merchant_1.bulk_discounts.create!(name: "Crazy Fall Sale", qty_threshold: 15, pct_discount: 25)
      discount_3 = merchant_1.bulk_discounts.create!(name: "Mellow Deals", qty_threshold: 5, pct_discount: 10)

      expect(invoice_1.disc_amount).to eq(750.0)
      expect(invoice_2.disc_amount).to eq(1140.0)
      expect(invoice_3.disc_amount).to eq(0.0)
      expect(invoice_4.disc_amount).to eq(540.0)
      expect(invoice_5.disc_amount).to eq(4464.0)
      expect(invoice_6.disc_amount).to eq(0.0)
    end
  end
end

    # it '#discount revenue' do
    #   merchant_1 = Merchant.create!(name: "Bobs Loggers")

    #   item_1 = Item.create!(name: "Log", description: "Wood, maple", unit_price: 200, merchant_id: merchant_1.id )
    #   item_2 = Item.create!(name: "Saw", description: "Metal, sharp", unit_price: 300, merchant_id: merchant_1.id )
    #   item_3 = Item.create!(name: "Bench", description: "Cedar bench", unit_price: 400, merchant_id: merchant_1.id )
    #   item_4 = Item.create!(name: "Axe", description: "Big Axe", unit_price: 500, merchant_id: merchant_1.id )
    #   item_5 = Item.create!(name: "Hammer", description: "Carpenter's hammer, wood handle", unit_price: 600, merchant_id: merchant_1.id )
    #   item_6 = Item.create!(name: "Speed Square", description: "Metal w/ level", unit_price: 700, merchant_id: merchant_1.id )
    #   item_7 = Item.create!(name: "Mallet", description: "Wooden carpenter's mallet", unit_price: 800, merchant_id: merchant_1.id )
    #   item_8 = Item.create!(name: "Reciprocating Saw", description: "Electric reciprocating saw", unit_price: 900, merchant_id: merchant_1.id )

    #   customer_1 = Customer.create!(first_name: "David", last_name: "Smith")
    #   customer_2 = Customer.create!(first_name: "Cindy", last_name: "Lou")
    #   customer_3 = Customer.create!(first_name: "John", last_name: "Johnson")
    #   customer_4 = Customer.create!(first_name: "Mary", last_name: "Vale")

    #   invoice_1 = Invoice.create!(status: 0, customer_id: customer_1.id)
    #   invoice_2 = Invoice.create!(status: 0, customer_id: customer_2.id)
    #   invoice_3 = Invoice.create!(status: 2, customer_id: customer_3.id)
    #   invoice_4 = Invoice.create!(status: 2, customer_id: customer_4.id)
    #   invoice_5 = Invoice.create!(status: 0, customer_id: customer_4.id)
    #   invoice_6 = Invoice.create!(status: 0, customer_id: customer_4.id)

    #   invoice_item_1 = InvoiceItem.create!(quantity: 15, unit_price: 200, status: 0, item_id: item_1.id, invoice_id: invoice_1.id)
    #   invoice_item_2 = InvoiceItem.create!(quantity: 2, unit_price: 300, status: 1, item_id: item_2.id, invoice_id: invoice_1.id)
    #   invoice_item_3 = InvoiceItem.create!(quantity: 10, unit_price: 400, status: 2, item_id: item_3.id, invoice_id: invoice_2.id)
    #   invoice_item_4 = InvoiceItem.create!(quantity: 11, unit_price: 500, status: 1, item_id: item_4.id, invoice_id: invoice_2.id)
    #   invoice_item_5 = InvoiceItem.create!(quantity: 3, unit_price: 600, status: 2, item_id: item_5.id, invoice_id: invoice_3.id)
    #   invoice_item_6 = InvoiceItem.create!(quantity: 2, unit_price: 700, status: 0, item_id: item_6.id, invoice_id: invoice_3.id)
    #   invoice_item_7 = InvoiceItem.create!(quantity: 3, unit_price: 800, status: 2, item_id: item_7.id, invoice_id: invoice_4.id)
    #   invoice_item_8 = InvoiceItem.create!(quantity: 6, unit_price: 900, status: 2, item_id: item_8.id, invoice_id: invoice_4.id)
    #   invoice_item_9 = InvoiceItem.create!(quantity: 16, unit_price: 900, status: 1, item_id: item_8.id, invoice_id: invoice_5.id)
    #   invoice_item_10 = InvoiceItem.create!(quantity: 12, unit_price: 600, status: 1, item_id: item_5.id, invoice_id: invoice_5.id)
    #   invoice_item_11 = InvoiceItem.create!(quantity: 3, unit_price: 500, status: 1, item_id: item_4.id, invoice_id: invoice_5.id)
    #   invoice_item_12 = InvoiceItem.create!(quantity: 4, unit_price: 500, status: 1, item_id: item_1.id, invoice_id: invoice_6.id)

    #   discount_1 = merchant_1.bulk_discounts.create!(name: "November Deal - Black Thursday!", qty_threshold: 10, pct_discount: 12)
    #   discount_2 = merchant_1.bulk_discounts.create!(name: "Crazy Fall Sale", qty_threshold: 15, pct_discount: 25)
    #   discount_3 = merchant_1.bulk_discounts.create!(name: "Mellow Deals", qty_threshold: 5, pct_discount: 10)

    #   expect(invoice_1.total_revenue).to eq(3600)
    #   expect(invoice_1.discount_revenue).to eq(2700)

    #   expect(invoice_2.total_revenue).to eq(9500)
    #   expect(invoice_2.discount_revenue).to eq(8360)

    #   expect(invoice_3.total_revenue).to eq(3200)
    #   expect(invoice_3.discount_revenue).to eq(0)

    #   expect(invoice_4.total_revenue).to eq(7800)
    #   expect(invoice_4.discount_revenue).to eq(7020)

    #   expect(invoice_5.total_revenue).to eq(23100)
    #   expect(invoice_5.discount_revenue).to eq(17325)

    #   expect(invoice_6.total_revenue).to eq(2000)
    #   expect(invoice_6.discount_revenue).to eq(0)
    # end
