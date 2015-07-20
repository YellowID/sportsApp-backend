require 'rails_helper'

describe V1::ApiSportType, type: :request do
  include APIHelpers

  describe 'GET /sport_types' do
    let!(:first_sport_type) { create(:sport_type) }
    let!(:second_sport_type) { create(:sport_type) }

    it 'returns sport type list' do
      get api('/sport_types')

      expect(response.status).to eq(200)
      expect(json_response.count).to eq(2)
    end
  end

  describe 'POST /sport_types/:id/level' do
    let(:user) { create(:user) }
    let(:sport_type) { create(:sport_type) }

    before do
      user.sport_types << sport_type
    end

    it 'changes sport type level' do
      post api("/sport_types/#{sport_type.id}/level", user), {level: 3}

      expect(response.status).to eq(201)
      expect(user.sport_setting(sport_type).level).to eq(3)
    end
  end

  describe 'GET /sport_types/:id/level' do
    let(:user) { create(:user) }
    let(:sport_type) { create(:sport_type) }

    before do
      user.sport_types << sport_type

      user.sport_setting(sport_type).update(level: 2)
    end

    it 'changes sport type level' do
      get api("/sport_types/#{sport_type.id}/level", user)

      expect(response.status).to eq(200)
      expect(json_response['level']).to eq(2)
    end
  end
end


