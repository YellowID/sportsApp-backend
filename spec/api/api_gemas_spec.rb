require 'rails_helper'

describe V1::ApiGames, type: :request do
  include APIHelpers

  let(:user) { create(:user) }

  describe 'POST /games' do
    let!(:sport_type) { create(:sport_type) }

    context 'when data is valid' do
      it 'create new game' do
        params = {
          sport_type_id: sport_type.id,
          start_at: '10.10.2015',
          age: 21,
          numbers: 10,
          level: 1,
          title: 'title',
          country: 'Country',
          city: 'City',
          address: 'Address',
          latitude: 2.12321,
          longitude: 4.1232
        }

        post api("/games", user), params

        expect(response.status).to eq(201)
        expect(json_response['age']).to eq(21)
        expect(json_response['numbers']).to eq(10)
        expect(json_response['sport_type']['name']).to eq(sport_type.name)
        expect(json_response['city']).to eq('City')
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

        post api("/games", user), params

        expect(response.status).to eq(400)
      end
    end
  end

  describe 'DELETE /games/:id' do
    let(:game) { create(:game, user: user) }

    it 'delete game' do
      delete api("/games/#{game.id}", user)

      expect(response.status).to eq(200)
      expect(json_response['result']).to eq('success')
    end
  end

  describe 'PATCH /games/:id' do
    let(:game) { create(:game, user: user, age: 19, numbers: 5) }

    it 'create new game' do
      params =  {
        age: 21
      }

      patch api("/games/#{game.id}", user), params

      expect(response.status).to eq(200)
      expect(json_response['age']).to eq(21)
      expect(json_response['numbers']).to eq(5)
    end
  end

  describe 'GET /games' do
    let(:game) { create(:game, user: user, age: 19, numbers: 5) }

    it 'gets games list' do
      get api("/games", user)

      expect(response.status).to eq(200)
    end
  end

  describe 'POST /games/:id/members' do
    let(:game) { create(:game, user: user) }
    let(:member) {create(:user) }

    it 'add member to game' do
      post api("/games/#{game.id}/members", member)

      expect(response.status).to eq(201)
      expect(member.participate_games.to_a.include?(game)).to be_truthy
    end
  end

end
