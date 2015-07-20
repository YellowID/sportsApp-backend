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

      route_param :id do
        desc 'Set sport types level'

        params do
          requires :level, type: Integer
        end

        post :level do
          sport_type = SportType.find(params[:id])
          setting = current_user.sport_setting(sport_type)

          setting.update(level: params[:level])

          result_success
        end

        desc 'Get sport types level'

        get :level do
          sport_type = SportType.find(params[:id])
          setting = current_user.sport_setting(sport_type)

          present level: setting.level
        end
      end
    end
  end
end
