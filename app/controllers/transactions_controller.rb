class TransactionsController < ApplicationController
  require 'httpparty'
  before_action :set_user, only: [:index, :create]

  # Listado de transacciones de un usuario
  def index
    transactions = @user.transactions
    render json: transactions, status: :ok
  end

  # Detalle de una transacción específica
  def show
    transaction = Transaction.find(params[:id])
    render json: transaction, status: :ok
  end


  def create
    currency_from = params[:currency_from]
    currency_to = params[:currency_to]
    amount = params[:amount].to_d

    begin
      ActiveRecord::Base.transaction do
        if currency_from == 'USD' && currency_to == 'BTC'
          process_buy_transaction(amount)
        elsif currency_from == 'BTC' && currency_to == 'USD'
          process_sell_transaction(amount)
        else
          raise StandardError, 'Invalid currency exchange'
        end
      end

      transaction = @user.transactions.last
      render json: { message: 'Transaction completed successfully', transaction: transaction }, status: :created
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end


  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def get_current_btc_price
    response = HTTParty.get('https://api.coindesk.com/v1/bpi/currentprice.json')
    parsed_response = response.parsed_response
    parsed_response.dig('bpi', 'USD', 'rate_float') rescue nil
  end

  def process_buy_transaction(amount_usd)
    usd_to_btc = get_current_btc_price
    raise StandardError, 'Unable to fetch BTC price' unless usd_to_btc

    amount_btc = amount_usd / usd_to_btc

    if @user.balance_usd >= amount_usd
      @user.update!(balance_usd: @user.balance_usd - amount_usd)
      @user.transactions.create!(transaction_type: 'buy', amount_usd: amount_usd, amount_btc: amount_btc)
    else
      raise StandardError, 'Insufficient funds'
    end
  end

  def process_sell_transaction(amount_btc)
    usd_to_btc = get_current_btc_price
    raise StandardError, 'Unable to fetch BTC price' unless usd_to_btc

    amount_usd = amount_btc * usd_to_btc

    if @user.balance_btc >= amount_btc
      @user.update!(balance_btc: @user.balance_btc - amount_btc)
      @user.update!(balance_usd: @user.balance_usd + amount_usd)
      @user.transactions.create!(transaction_type: 'sell', amount_usd: amount_usd, amount_btc: amount_btc)
    else
      raise StandardError, 'Insufficient BTC balance'
    end
  end
end