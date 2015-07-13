module V1
  module Entities
    class Game < Grape::Entity
      expose(:id, documentation: { type: 'integer' })
      expose(:user, using: Entities::User)
      expose(:sport_type, using: Entities::SportType)
      expose(:start_at, documentation: { type: 'string' })
      expose(:age, documentation: { type: 'integer' })
      expose(:numbers, documentation: { type: 'integer' })
      expose(:level, documentation: { type: 'string' })
    end
  end

  class ApiGames < Grape::API
    resource :users do
      route_param :user_id do
        resource :games do
          desc 'Create new game'

          params do
            requires :sport_type_id, type: Integer
            requires :start_at, type: DateTime
            requires :age, type: Integer
            requires :numbers, type: Integer
            requires :level, type: Integer
          end

          post do
            user = User.find(params[:user_id])

            game = user.games.create!(
              sport_type_id: params[:sport_type_id],
              start_at: params[:start_at],
              age: params[:age],
              numbers: params[:numbers],
              level: params[:level]
            )

            present game, with: Entities::Game
          end
        end
      end
    end
  end
end


