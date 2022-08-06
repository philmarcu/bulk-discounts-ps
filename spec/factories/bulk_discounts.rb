FactoryBot.define do
  factory :bulk_discount do
    qty_threshold { Faker::Number.between(from: 1, to: 100) }
    pct_discount { Faker::Number.between(from: 1, to: 50) }
  end
end
