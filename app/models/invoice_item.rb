class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity
  validates_presence_of :unit_price
  validates_presence_of :status

  belongs_to :item
  belongs_to :invoice
  has_many :bulk_discounts, through: :item

  enum status: { "pending" => 0, "packaged" => 1, "shipped" => 2 }

  # def applied_discount 
  #   bulk_discounts.select('bulk_discounts.*, max(bulk_discounts.pct_discount) as pct')
  #   .group('bulk_discounts.id')
  #   .first
  #   binding.pry
  # end
end
