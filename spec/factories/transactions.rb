FactoryBot.define do
  factory :transaction do
    association :user
    transaction_type { "buy" }
    amount_usd { 100.0 }
    amount_btc { 0.005 }
  end
end