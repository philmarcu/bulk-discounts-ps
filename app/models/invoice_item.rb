class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity
  validates_presence_of :unit_price
  validates_presence_of :status

  belongs_to :item
  belongs_to :invoice
  has_many :bulk_discounts, through: :item

  enum status: { "pending" => 0, "packaged" => 1, "shipped" => 2 }
end
