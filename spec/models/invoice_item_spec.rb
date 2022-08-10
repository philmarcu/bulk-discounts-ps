require 'rails_helper'

RSpec.describe InvoiceItem do
  describe 'validations' do
    it { should validate_presence_of(:quantity)}
    it { should validate_presence_of(:unit_price)}
    it { should validate_presence_of(:status)}
  end

  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :invoice }
    it { should have_many(:bulk_discounts).through(:item)}
  end
end

  describe '#instance_methods' do
    xit 'can get applied discounts' do
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
      invoice_item_5 = InvoiceItem.create!(quantity: 13, unit_price: 600, status: 2, item_id: item_5.id, invoice_id: invoice_3.id)
      invoice_item_6 = InvoiceItem.create!(quantity: 5, unit_price: 700, status: 0, item_id: item_6.id, invoice_id: invoice_3.id)

      discount_1 = merchant_1.bulk_discounts.create!(name: "November Deal - Black Thursday!", qty_threshold: 10, pct_discount: 12)
      discount_2 = merchant_1.bulk_discounts.create!(name: "Crazy Fall Sale", qty_threshold: 15, pct_discount: 25)

      expect(invoice_item_1.applied_discount).to eq(nil)
      expect(invoice_item_2.applied_discount).to eq(discount_2)
      expect(invoice_item_3.applied_discount).to eq(nil)
      expect(invoice_item_4.applied_discount).to eq(discount_1)
      expect(invoice_item_5.applied_discount).to eq(discount_1)
      expect(invoice_item_6.applied_discount).to eq(nil)
    end
  end