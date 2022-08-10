class CreateDiscountItems < ActiveRecord::Migration[5.2]
  def change
    create_table :discount_items do |t|
      t.integer :quantity
      t.integer :price
      t.references :item, foreign_key: true
      t.references :bulk_discount, foreign_key: true
      t.timestamps
    end
  end
end
