require 'swagger_helper'

RSpec.describe 'prices', type: :request do

  path '/prices/btc_to_usd' do

    get('show price') do
      tags 'Get Price BTC'
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
