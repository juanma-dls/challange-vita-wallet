require 'rails_helper'

RSpec.describe PricesController, type: :controller do
  describe "GET #show" do
    context "when API call is successful" do
      before do
        allow(HTTParty).to receive(:get).and_return(double(success?: true, parsed_response: {
          'bpi' => { 'USD' => { 'code' => 'USD', 'description' => 'United States Dollar', 'rate' => '30000.0' } },
          'time' => { 'updated' => 'Jun 26, 2024 00:00:00 UTC' }
        }))
      end

      it "returns a successful response" do
        get :show
        expect(response).to have_http_status(:ok)
      end

      it "returns the correct BTC price data" do
        get :show
        json_response = JSON.parse(response.body)
        expect(json_response['usd_code']).to eq('USD')
        expect(json_response['usd_description']).to eq('United States Dollar')
        expect(json_response['btc_usd']).to eq('30000.0')
        expect(json_response['time_updated']).to eq('Jun 26, 2024 00:00:00 UTC')
      end
    end

    context "when API call fails" do
      before do
        allow(HTTParty).to receive(:get).and_return(double(success?: false))
      end

      it "returns an error" do
        expect {
          get :show
        }.to raise_error(PricesController::ExternalApiError, 'Error connecting to Coindesk API')
      end
    end

    context "when API returns unexpected data" do
      before do
        allow(HTTParty).to receive(:get).and_return(double(success?: true, parsed_response: {}))
      end

      it "raises an error" do
        expect {
          get :show
        }.to raise_error(PricesController::ExternalApiError, 'Unable to fetch BTC price')
      end
    end
  end
end
