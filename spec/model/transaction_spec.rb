# spec/models/transaction_spec.rb
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it 'is valid with valid attributes' do
    user = User.create(email: 'test@example.com', balance_usd: 1000, balance_btc: 1)
    transaction = Transaction.new(user: user, transaction_type: 'buy', amount_usd: 100, amount_btc: 0.01)
    expect(transaction).to be_valid
  end

  it 'is not valid without a transaction_type' do
    user = User.create(email: 'test@example.com', balance_usd: 1000, balance_btc: 1)
    transaction = Transaction.new(user: user, amount_usd: 100, amount_btc: 0.01)
    expect(transaction).not_to be_valid
  end

  it 'is not valid with a negative amount_usd' do
    user = User.create(email: 'test@example.com', balance_usd: 1000, balance_btc: 1)
    transaction = Transaction.new(user: user, transaction_type: 'buy', amount_usd: -1, amount_btc: 0.01)
    expect(transaction).not_to be_valid
  end

  it 'is not valid with a negative amount_btc' do
    user = User.create(email: 'test@example.com', balance_usd: 1000, balance_btc: 1)
    transaction = Transaction.new(user: user, transaction_type: 'buy', amount_usd: 100, amount_btc: -0.01)
    expect(transaction).not_to be_valid
  end
end
