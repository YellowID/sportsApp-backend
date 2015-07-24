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

    class FullGame < Grape::Entity
      expose(:id, documentation: { type: 'integer' })
      expose(:user, using: Entities::User)
      expose(:sport_type, using: Entities::SportType)
      expose(:start_at, documentation: { type: 'string' })
      expose(:title, documentation: { type: 'string' })
      expose(:country, documentation: { type: 'string' })
      expose(:city, documentation: { type: 'string' })
      expose(:address, documentation: { type: 'string' })
      expose(:latitude, documentation: { type: 'decimal' })
      expose(:longitude, documentation: { type: 'decimal' })
      expose(:age, documentation: { type: 'integer' })
      expose(:numbers, documentation: { type: 'integer' })
      expose(:level, documentation: { type: 'string' })
      expose(:members, using: Entities::User)
    end
  end

  class ApiGames < Grape::API
    params do
      requires :user_token, type: String
    end

    resource :games do
      desc 'Games List', {
        entity: Entities::Game
      }

      get do
        games = current_user.participate_games

        present games, with: Entities::Game
      end

      desc 'Create new game', {
        entity: Entities::Game
      }

      params do
        requires :sport_type_id, type: Integer
        requires :start_at, type: DateTime
        requires :age, type: Integer
        requires :numbers, type: Integer
        requires :level, type: Integer
        requires :title, type: String
        requires :country, type: String
        requires :city, type: String
        requires :address, type: String
        requires :latitude, type: Float
        requires :longitude, type: Float
      end

      post do
        game = current_user.games.create!(
          sport_type_id: params[:sport_type_id],
          start_at: params[:start_at],
          age: params[:age],
          numbers: params[:numbers],
          level: params[:level],
          title: params[:title],
          country: params[:country],
          city: params[:city],
          address: params[:address],
          latitude: params[:latitude],
          longitude: params[:longitude]
        )

        current_user.participate_games << game

        present game, with: Entities::FullGame
      end

      route_param :id do
        desc 'Get Game', {
          entity: Entities::FullGame
        }

        get do
          game = Game.find(params[:id])

          present game, with: Entities::FullGame
        end

        desc 'Edit game', {
          entity: Entities::Game
        }

        params do
          optional :start_at, type: DateTime
          optional :age, type: Integer
          optional :numbers, type: Integer
          optional :level, type: Integer
        end

        patch do
          attributes = %i(start_at age numbers level).each_with_object({}) do |param, hs|
            hs[param] = params[param] if params.has_key?(param)
          end

          game = current_user.games.find(params[:id])

          game.update(attributes)

          present game, with: Entities::Game
        end

        desc 'Destroy game'

        delete do
          current_user.games.find(params[:id]).destroy!

          result_success
        end

        resource :member do

          desc 'take participate in game'

          post do
            game = Game.find(params[:id])

            game.members << current_user

            result_success
          end

          desc 'Leave game'

          delete do
            game = Game.find(params[:id])

            game.members.delete(current_user)

            result_success
          end

          desc 'refuse member in game'

          route_param :member_id do
            delete do
              game = current_user.games.find(params[:id])
              member = User.find(params[:member_id])

              game.members.delete(member)

              result_success
            end
          end
        end
      end
    end
  end
end
