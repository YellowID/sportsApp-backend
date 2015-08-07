module V1
  module Entities
    class User < Grape::Entity
      expose(:id, documentation: { type: 'integer' })
      expose(:avatar, documentation: { type: 'string' })
      expose(:name, documentation: { type: 'string' })
    end

    class FullUser < Grape::Entity
      expose(:id, documentation: { type: 'integer' })
      expose(:provider, documentation: { type: 'string' })
      expose(:avatar, documentation: { type: 'string' })
      expose(:provider_id, documentation: { type: 'string' })
      expose(:email, documentation: { type: 'string' })
      expose(:name, documentation: { type: 'string' })
      expose(:age, documentation: { type: 'integer' })
      expose(:token, documentation: { type: 'string' })
      expose(:chat_password, documentation: { type: 'string' })
    end

    class UserSetting < Grape::Entity
      expose(:age, documentation: { type: 'integer' })
      expose(:level, documentation: { type: 'integer' })
      expose(:sport_types) { |user| user.sport_type_ids }
    end
  end

  class ApiUsers < Grape::API
    resource :users do
      params do
        requires :user_token, type: String
      end

      desc 'Get user settings'

      get :settings do
        present current_user, with: Entities::UserSetting
      end

      resource :find_by_name do

        params do
          optional :name, type: String
        end

        desc 'Get ser info by user name'

        get  do
          users = User.where("name ILIKE ?", "%#{params[:name]}%")

          present users, with: Entities::User
        end
      end


      desc 'Authenticate user'

      params do
        optional :name, type: String
        optional :email, type: String
        optional :avatar, type: String
        requires :provider, type: String
        requires :provider_id, type: String
      end

      post :authentication do
        user = User.find_or_initialize_by(
          provider: params[:provider],
          provider_id: params[:provider_id]
        )

        unless user.persisted?
          user.tap do |u|
            u.chat_password = SecureRandom.base64(8)
            u.name = params[:name]
            u.email = params[:email]
            u.avatar = params[:avatar]
          end.save!

          user.sport_type_ids = SportType.ids
        end

        user.generate_token!

        present user, with: Entities::FullUser
      end

      route_param :id do
        desc 'Get ser info'

        get do
          user = User.find(params[:id])

          present user, with: Entities::User
        end
      end

      desc 'Set user settings'

      params do
        requires :age, type: Integer
        requires :level, type: Integer
        requires :sport_type_ids, type: Array
        requires :user_token, type: String
      end

      patch :settings do
        current_user.update(update_attributes(%i(age level)))
        current_user.sport_type_ids = params[:sport_type_ids]

        result_success
      end
    end
  end
end

