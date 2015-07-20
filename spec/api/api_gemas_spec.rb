require 'rails_helper'

describe V1::ApiGames, type: :request do
  include APIHelpers

  let(:user) { create(:user) }

  describe 'POST /users/:user_id/games' do
    let!(:sport_type) { create(:sport_type) }

    context 'when data is valid' do
      it 'create new game' do
        params =  {
          sport_type_id: sport_type.id,
          start_at: '10.10.2015',
          age: 21,
          numbers: 10,
          level: 1
        }

        post api("/users/#{user.id}/games"), params

        expect(response.status).to eq(201)
        expect(json_response['age']).to eq(21)
        expect(json_response['numbers']).to eq(10)
        expect(json_response['sport_type']['name']).to eq(sport_type.name)
      end
    end

    context 'when data is invalid' do
      it 'doesnt create new game' do
         params =  {
          start_at: '10.10.2015',
          age: 21,
          numbers: 10,
          level: 1
        }

        post api("/users/#{user.id}/games"), params

        expect(response.status).to eq(400)
      end
    end
  end

  describe 'DELETE /users/:user_id/games/:id' do
    let(:game) { create(:game, user: user) }

    it 'delete game' do
      delete api("/users/#{user.id}/games/#{game.id}")

      expect(response.status).to eq(200)
      expect(json_response['result']).to eq('success')
    end
  end

  describe 'PATCH /users/:user_id/games/:id' do
    let(:game) { create(:game, user: user, age: 19, numbers: 5) }

    it 'create new game' do
      params =  {
        age: 21
      }

      patch api("/users/#{user.id}/games/#{game.id}"), params

      expect(response.status).to eq(200)
      expect(json_response['age']).to eq(21)
      expect(json_response['numbers']).to eq(5)
    end
  end

  describe 'GET /users/:user_id/games' do
    let(:game) { create(:game, user: user, age: 19, numbers: 5) }

    it 'gets games list' do
      get api("/users/#{user.id}/games")

      expect(response.status).to eq(200)
    end
  end
end
