require 'rails_helper'

describe V1::ApiUsers, type: :request do
  include APIHelpers

  describe 'POST /users/authentication' do
    context 'when data is valid' do
      it 'create new user' do
        params =  { oauth_token: 'oauth_token',
          provider: 'facebook',
          email: 'email@mail.com',
          name: 'Full Name' }

        post api('/users/authentication'), params

        expect(response.status).to eq(201)
        expect(json_response['oauth_token']).to eq('oauth_token')
        expect(json_response['provider']).to eq('facebook')
        expect(json_response['email']).to eq('email@mail.com')
      end
    end

    context 'when data is invalid' do
      it 'create new user' do
        params =  { oauth_token: 'oauth_token',
          email: 'email@mail.com',
          name: 'Full Name' }

        post api('/users/authentication'), params

        expect(response.status).to eq(400)
      end
    end
  end
end

