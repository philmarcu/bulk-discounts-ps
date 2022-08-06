class BulkDiscount < ApplicationRecord
  validates :qty_threshold, presence: true, numericality: true
  validates :pct_discount, presence: true, numericality: true

  belongs_to :merchant
  has_many :items, through: :merchant
end