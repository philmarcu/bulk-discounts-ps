class DiscountItem < ApplicationRecord
  validates :quantity, presence: true, numericality: true
  validates :price, presence: true, numericality: true

  belongs_to :item
  belongs_to :bulk_discount
  has_many :invoices, through: :item
end