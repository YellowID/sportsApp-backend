module V1
  module Entities
    class SportType < Grape::Entity
      expose(:id, documentation: { type: 'integer' })
      expose(:name, documentation: { type: 'string' })
    end
  end

  class ApiSportType < Grape::API
    resource :sport_types do
      desc 'Get sport type list'

      get do
        sport_types = SportType.all

        present sport_types, with: Entities::SportType
      end
    end
  end
end


