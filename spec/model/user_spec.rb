# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = User.new(email: 'test@example.com', balance_usd: 1000, balance_btc: 1)
    expect(user).to be_valid
  end

  it 'is not valid without an email' do
    user = User.new(balance_usd: 1000, balance_btc: 1)
    expect(user).not_to be_valid
  end

  it 'is not valid with a non-unique email' do
    User.create(email: 'test@example.com', balance_usd: 1000, balance_btc: 1)
    user = User.new(email: 'test@example.com', balance_usd: 1000, balance_btc: 1)
    expect(user).not_to be_valid
  end

  it 'is not valid with a negative balance_usd' do
    user = User.new(email: 'test@example.com', balance_usd: -1, balance_btc: 1)
    expect(user).not_to be_valid
  end

  it 'is not valid with a negative balance_btc' do
    user = User.new(email: 'test@example.com', balance_usd: 1000, balance_btc: -1)
    expect(user).not_to be_valid
  end
end