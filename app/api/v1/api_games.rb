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

    class GameWithState < Game
      expose(:participate_status, documentation: { type: 'string' })
    end

    class FullGame < GameWithState
      expose(:title, documentation: { type: 'string' })
      expose(:country, documentation: { type: 'string' })
      expose(:city, documentation: { type: 'string' })
      expose(:address, documentation: { type: 'string' })
      expose(:latitude, documentation: { type: 'decimal' })
      expose(:longitude, documentation: { type: 'decimal' })
      expose(:members, using: Entities::User)
    end

    class MemeberGames < Grape::Entity
      expose(:id, documentation: { type: 'integer' }) { |data| data.game.id }
      expose(:user_id, documentation: { type: 'integer' }) { |data| data.game.user_id }
      expose(:sport_type_id, documentation: { type: 'integer' }) { |data| data.game.sport_type_id }
      expose(:start_at, documentation: { type: 'string' }) { |data| data.game.start_at }
      expose(:age, documentation: { type: 'integer' }) { |data| data.game.age }
      expose(:numbers, documentation: { type: 'integer' }) { |data| data.game.numbers }
      expose(:level, documentation: { type: 'string' }) { |data| data.game.level }
      expose(:title, documentation: { type: 'string' }) { |data| data.game.title }
      expose(:address, documentation: { type: 'string' }) { |data| data.game.address }
      expose(:participate_status, documentation: { type: 'string' }) { |data| data.participate_status }
      expose(:title, documentation: { type: 'string' }) { |data| data.game.title }
      expose(:country, documentation: { type: 'string' }) { |data| data.game.country }
      expose(:city, documentation: { type: 'string' }) { |data| data.game.city }
      expose(:address, documentation: { type: 'string' }) { |data| data.game.address }
      expose(:latitude, documentation: { type: 'decimal' }) { |data| data.game.latitude }
      expose(:longitude, documentation: { type: 'decimal' }) { |data| data.game.longitude }
      expose(:members) { |data| data.members }
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

            members = game.game_members.where.not(state: :rejected).includes(:user).map do |member|
              user = member.userd

              {
                id: user.id,
                avatar: user.avatar,
                name: user.name,
                participate_status: member.state
              }
            end
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
        my_games = current_user.my_games.includes(:game_members)

        other_games = params[:city].present? ? Game.where(city: params[:city]) : Game.all

        public_games = other_games - my_games

        my_games.map do |game|
          participate_status = game.state(current_user.id)

          game.define_singleton_method(:participate_status) do
            participate_status
          end

          game
        end

        present :my, my_games, with: Entities::GameWithState
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

        present game, with: Entities::Game
      end

      route_param :id do
        desc 'Get Game', {
          entity: Entities::FullGame
        }

        get do
          game = Game.find(params[:id])

          participate_status = game.state(current_user.id)

          members = game.game_members.where.not(state: :rejected).includes(:user).map do |member|
            user = member.user

            {
              id: user.id,
              avatar: user.avatar,
              name: user.name,
              participate_status: member.state
            }
          end

          data = OpenStruct.new(
            game: game,
            participate_status: participate_status,
            members: members
          )

          present data, with: Entities::MemeberGames
        end

        desc 'Edit game', {
          entity: Entities::Game
        }

        params do
          optional :start_at, type: DateTime
          optional :age, type: Integer
          optional :numbers, type: Integer
          optional :level, type: Integer
          optional :title, type: String
          optional :latitude, type: Float
          optional :longitude, type: Float
          optional :country, type: String
          optional :city, type: String
          optional :address, type: String
        end

        patch do
          game = current_user.games.find(params[:id])

          game.update(update_attributes(%i(start_at age numbers level title latitude longitude country city address)))

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
