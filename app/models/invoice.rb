class Invoice < ApplicationRecord
  validates_presence_of :status

  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :bulk_discounts, through: :items

  enum status: { "in progress" => 0, "cancelled" => 1, "completed" => 2 }

  def self.incomplete_invoices
  joins(:invoice_items)
  .where.not(invoice_items: { status: 2 })
  .order(:created_at)
  .distinct
  end

  def total_revenue
   invoice_items.sum("unit_price * quantity")
  end

  def discount_items
    invoice_items.joins(item: :bulk_discounts)
    .select('invoice_items.*, invoice_items.quantity AS qty')
    .where('bulk_discounts.qty_threshold <= invoice_items.quantity')
    .order('qty desc')
    .distinct
  end

  def discount_revenue
    discounts = bulk_discounts.distinct
    max = discounts.max_by {|d| d.pct_discount }
    min = discounts.min_by {|d| d.pct_discount }

    
    discount_items.sum do |item|
      if max.qty_threshold <= item.quantity
        amt = max.rate * total_revenue
        return (total_revenue - amt).to_i   
      elsif min.qty_threshold <= item.quantity
        amt = min.rate * total_revenue
        return (total_revenue - amt).to_i 
      else 
        return nil
      end
    end
  end
end
