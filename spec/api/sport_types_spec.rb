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
end


