module V1
  module Entities
    class Game < Grape::Entity
      expose(:id, documentation: { type: 'integer' })
      expose(:user_id, documentation: { type: 'integer' })
      expose(:sport_type_id, documentation: { type: 'integer' })
      expose(:start_at, documentation: { type: 'string' })
      expose(:age, documentation: { type: 'integer' })
      expose(:numbers, documentation: { type: 'integer' })
      expose(:level, documentation: { type: 'string' })
      expose(:title, documentation: { type: 'string' })
      expose(:address, documentation: { type: 'string' })
    end

    class FullGame < Grape::Entity
      expose(:id, documentation: { type: 'integer' })
      expose(:user_id, documentation: { type: 'integer' })
      expose(:sport_type_id, documentation: { type: 'integer' })
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
    resource :games do
      resource :cityes do
        desc 'All games cities'

        get do
          cities = Game.pluck(:city).uniq.compact

          present cities
        end
      end

      route_param :id do
        resource :members do
          desc 'members list'

          get do
            game = Game.find(params[:id])

            present game.members, with: Entities::User
          end
        end
      end
    end

    params do
      requires :user_token, type: String
      optional :city, type: String
    end

    resource :games do
      desc 'Games List', {
        entity: Entities::Game
      }

      get do
        my_games = (current_user.participate_games + current_user.games).compact

        public_games = current_user.rejected_games

        if params[:city].present?
          cities_games = Game.where(city: params[:city]) - my_games - public_games
          public_games += cities_games
        end

        present :my, my_games, with: Entities::Game
        present :public, public_games, with: Entities::Game
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
        requires :latitude, type: Float
        requires :longitude, type: Float
        optional :country, type: String
        optional :city, type: String
        optional :address, type: String
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
          game = current_user.games.find(params[:id])

          game.update(update_attributes(%i(start_at age numbers level)))

          present game, with: Entities::Game
        end

        desc 'Destroy game'

        delete do
          current_user.games.find(params[:id]).destroy!

          result_success
        end
      end
    end
  end
end
