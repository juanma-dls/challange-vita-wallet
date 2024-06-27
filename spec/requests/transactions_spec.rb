require 'swagger_helper'

RSpec.describe 'transactions', type: :request do

  path '/users/{user_id}/transactions' do
    # You'll want to customize the parameter types...
    parameter name: 'user_id', in: :path, type: :string, description: 'user_id'

    get('list transactions') do
      tags 'List transactions especific user'
      response(200, 'successful') do
        let(:user_id) { '123' }

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

    require 'swagger_helper'

    post('create transaction') do
      tags 'Create transaction especific user'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer
      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          currency_from: { type: :string, example: 'USD' },
          currency_to: { type: :string, example: 'BTC' },
          amount: { type: :number, example: 100.00 }
        },
        required: ['currency_from', 'currency_to', 'amount']
      }

      response(201, 'successful') do
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:transaction) do
          {
            currency_from: 'USD',
            currency_to: 'BTC',
            amount: 100.00
          }
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:user) { create(:user) }
        let(:user_id) { user.id }
        let(:transaction) do
          {
            currency_from: 'USD',
            currency_to: 'EUR',
            amount: 100.00
          }
        end

        run_test!
      end
    end    
  end

  path '/users/{user_id}/transactions/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'user_id', in: :path, type: :string, description: 'user_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show transaction') do
      tags 'Show transaction'
      response(200, 'successful') do
        let(:user_id) { '123' }
        let(:id) { '123' }

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
