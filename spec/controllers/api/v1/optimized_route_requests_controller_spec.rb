# frozen_string_literal: true

RSpec.describe Api::V1::OptimizedRouteRequestsController do
  describe '#index' do
    context 'when given valid input' do
      it 'responds with a 200 and an optimized route' do
        valid_input = {
          provider: '84c665b2-0b84-45be-8ffc-adec6bb30feb',
          geo_coordinates: [35.949464, -86.8060602].to_json,
          addresses: [
            { street_address: '333 Commerce St.', city: 'Nashville', state: 'TN', zip: '37201' },
            { street_address: '1005 Flagpole Ct.', city: 'Brentwood', state: 'TN', zip: '37027' }
          ].to_json
        }

        get :index, params: valid_input

        expect(JSON.parse(response.body)).to eq(
          'data' => {
            'addresses' => [
              {
                'coordinates' => [35.95785, -86.80502],
                'street_address' => '1005 Flagpole Ct., Brentwood, TN 37027'
              },
              {
                'coordinates' => [36.16211, -86.7771],
                'street_address' => '333 Commerce St., Nashville, TN 37201'
              }
            ]
          }
        )
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when given invalid input' do
      it 'responds with a 422 and the expected validation errors' do
        invalid_input = {
          provider: '84c665b2-0b84-45be-8ffc-adec6bb30',
          geo_coordinates: [35.949464, -186.8060602].to_json,
          addresses: [
            { street_address: 'Invalid', city: 'Franklin', state: 'TN', zip: '37064' },
            { street_address: '1005 Flagpole Ct.', city: 'Brentwood', state: 'TN', zip: '37027' }
          ].to_json
        }

        get :index, params: invalid_input

        expect(JSON.parse(response.body)).to eq(
          'data' => {
            'error' => 'Provider invalid, Addresses contains at least one invalid address, Geo coordinates invalid'
          }
        )
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when an internal server error occurs' do
      it 'responds with a 500 and error details' do
        expect(OptimizedRouteRequest).to receive(:find_or_initialize_by).and_raise(StandardError, 'test error')

        get :index, params: {}

        res_body = JSON.parse(response.body)
        data = res_body['data']

        expect(data).to include('error' => 'StandardError')
        expect(data).to include('message' => 'test error')
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end
end
