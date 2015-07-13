require 'rails_helper'

describe V1::ApiGames, type: :request do
  include APIHelpers

  describe 'POST /users/:user_id/games' do
    let(:user) { create(:user) }
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
end
