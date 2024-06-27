class User < ApplicationRecord
  has_many :transactions

  validates :email, presence: true, uniqueness: true
  validates :balance_usd, numericality: { greater_than_or_equal_to: 0 }
  validates :balance_btc, numericality: { greater_than_or_equal_to: 0 }
end
