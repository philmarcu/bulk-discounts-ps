class Invoice < ApplicationRecord
  validates_presence_of :status

  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

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

  def disc_amount
    amt = invoice_items.joins(:bulk_discounts)
    .where('invoice_items.quantity >= bulk_discounts.qty_threshold')
    .select('invoice_items.id, max(invoice_items.quantity * invoice_items.unit_price * (bulk_discounts.pct_discount / 100.0)) AS disc_amt')
    .group('invoice_items.id')
    .sum(&:disc_amt)

    amt.to_f
  end
end

  # def discount_revenue
  #   discounts = bulk_discounts.distinct.sort_by {|d| d.pct_discount }.reverse

  #   discounts.sum do |discount|
  #     discount_items.sum do |item|
  #       if discount.qty_threshold <= item.quantity
  #         amt = discount.rate * total_revenue
  #         return (total_revenue - amt).to_i
  #       elsif discount.qty_threshold >= item.quantity
  #         arr = discounts.rotate(1)
  #         arr.sum do |d|
  #           if d.qty_threshold <= item.quantity
  #             amt = d.rate * total_revenue
  #             return (total_revenue - amt).to_i
  #           end
  #         end
  #       end
  #     end
  #   end
  # end
