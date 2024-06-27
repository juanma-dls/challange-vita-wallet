require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:user) { create(:user) }
  let(:transaction) { create(:transaction, user: user) }

  before do
    allow(User).to receive(:find).and_return(user)
    allow(HTTParty).to receive(:get).and_return(double(parsed_response: { 'bpi' => { 'USD' => { 'rate_float' => 20000.0 } } }))
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index, params: { user_id: user.id }
      expect(response).to have_http_status(:ok)
    end

    it "renders a list of transactions" do
      get :index, params: { user_id: user.id }
      expect(JSON.parse(response.body).size).to eq(user.transactions.count)
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { user_id: user.id, id: transaction.id }
      expect(response).to have_http_status(:ok)
    end

    it "renders the transaction" do
      get :show, params: { user_id: user.id, id: transaction.id }
      expect(JSON.parse(response.body)["id"]).to eq(transaction.id)
    end
  end

  describe "POST #create" do
    context "when buying BTC with USD" do
      it "creates a new transaction and returns success" do
        user.update(balance_usd: 50000)
        post :create, params: { user_id: user.id, currency_from: 'USD', currency_to: 'BTC', amount: 10000 }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["message"]).to eq('Transaction completed successfully')
        expect(user.transactions.last.transaction_type).to eq('buy')
      end
    end

    context "when selling BTC for USD" do
      it "creates a new transaction and returns success" do
        user.update(balance_btc: 1)
        post :create, params: { user_id: user.id, currency_from: 'BTC', currency_to: 'USD', amount: 0.5 }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["message"]).to eq('Transaction completed successfully')
        expect(user.transactions.last.transaction_type).to eq('sell')
      end
    end

    context "with invalid parameters" do
      it "returns an error" do
        post :create, params: { user_id: user.id, currency_from: 'USD', currency_to: 'EUR', amount: 10000 }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq('Invalid currency exchange')
      end
    end
  end
end
