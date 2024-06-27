class PricesController < ApplicationController
  require 'httparty'

  class ExternalApiError < StandardError; end

  def show
    response = HTTParty.get('https://api.coindesk.com/v1/bpi/currentprice.json')

    if response.success?
      parsed_response = response.parsed_response

      bpi_data = parsed_response['bpi']
      time_updated = parsed_response.dig('time', 'updated')

      if bpi_data && time_updated
        render json: { 
          usd_code: bpi_data.dig('USD', 'code'),
          usd_description: bpi_data.dig('USD', 'description'),
          btc_usd: bpi_data.dig('USD', 'rate'),
          time_updated: time_updated
        }, status: :ok
      else
        raise ExternalApiError, "Unable to fetch BTC price"
      end
    else
      raise ExternalApiError, 'Error connecting to Coindesk API'
    end
  end
end
