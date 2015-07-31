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

  describe 'PATCH /users/settings' do
    let!(:first_sport_type) { create(:sport_type) }
    let!(:second_sport_type) { create(:sport_type) }
    let(:user) { create(:user, age: 2, level: 2) }

    it 'changes age' do
      patch api("/users/settings", user), { age: 1, level: 3, sport_type_ids: [first_sport_type.id] }

      expect(response.status).to eq(200)
      expect(user.reload.age).to eq(1)
    end
  end

  describe 'GEt /users/:id' do
    let(:user) { create(:user, age: 1) }

    it 'changes age' do
      get api("/users/#{user.id}")

      expect(response.status).to eq(200)
      expect(json_response['id']).to eq(user.id)
    end
  end
end

