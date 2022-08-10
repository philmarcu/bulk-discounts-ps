class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity
  validates_presence_of :unit_price
  validates_presence_of :status

  belongs_to :item
  belongs_to :invoice
  has_many :bulk_discounts, through: :item

  enum status: { "pending" => 0, "packaged" => 1, "shipped" => 2 }

  def applied_discount 
    arr = bulk_discounts.order("pct_discount desc")
    highest = bulk_discounts.order("pct_discount desc").first

    if self.quantity >= highest.qty_threshold
      return highest
    elsif self.quantity <= highest.qty_threshold
      arr_2 = arr.rotate(1)
      if self.quantity >= arr_2.first.qty_threshold
        return arr_2.first
      end
    end
  end
end
