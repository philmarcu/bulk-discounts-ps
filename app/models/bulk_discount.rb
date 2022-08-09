class BulkDiscount < ApplicationRecord
  validates :qty_threshold, presence: true, numericality: true
  validates :pct_discount, presence: true, numericality: true

  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items

  def rate
    (self.pct_discount * 0.01).round(2)
  end

  def self.max_pct
    binding.pry
  end
end