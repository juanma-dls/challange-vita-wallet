class Transaction < ApplicationRecord
  belongs_to :user

  
  validates :transaction_type, presence: true, inclusion: { in: %w(buy sell) }
  validates :amount_usd, numericality: { greater_than: 0 }
  validates :amount_btc, numericality: { greater_than: 0 }
end
