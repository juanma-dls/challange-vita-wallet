FactoryBot.define do
  factory :user do
    email { "john@example.com" }
    balance_usd { 1000.0 }
    balance_btc { 1.0 }
  end
end