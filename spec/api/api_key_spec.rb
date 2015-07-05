require 'rails_helper'

describe 'ApiKey', type: :request do
  include APIHelpers

  context 'when api token is invalid' do
    it 'doesnt get access' do
      get '/api/v1/ping'

      expect(response.status).to eq(401)
    end

    context 'when api token is invalid' do
      it 'gets access' do
        get api('/ping')

        expect(response.status).to eq(200)
        expect(json_response['ping']).to eq('pong')
      end
    end
  end
end


