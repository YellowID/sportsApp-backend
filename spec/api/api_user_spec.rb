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

  describe 'POST /users/:user_id/sport_types/:id/level' do
    let(:user) { create(:user) }
    let(:sport_type) { create(:sport_type) }

    before do
      user.sport_types << sport_type
    end

    it 'changes sport type level' do
      post api("/users/#{user.id}/sport_types/#{sport_type.id}/level"), {level: 3}

      expect(response.status).to eq(201)
      expect(user.sport_setting(sport_type).level).to eq(3)
    end
  end

  describe 'GET /users/:user_id/sport_types/:id/level' do
    let(:user) { create(:user) }
    let(:sport_type) { create(:sport_type) }

    before do
      user.sport_types << sport_type

      user.sport_setting(sport_type).update(level: 2)
    end

    it 'changes sport type level' do
      get api("/users/#{user.id}/sport_types/#{sport_type.id}/level")

      expect(response.status).to eq(200)
      expect(json_response['level']).to eq(2)
    end
  end

  describe 'PATCH /users/:user_id/age' do
    let(:user) { create(:user, age: 1) }

    it 'changes age' do
      patch api("/users/#{user.id}/age"), { age: 2 }

      expect(response.status).to eq(200)
      expect(user.reload.age).to eq(2)
    end
  end
end

