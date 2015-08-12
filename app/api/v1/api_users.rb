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
      desc 'Get user settings'

      params do
        requires :user_token, type: String
      end

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
        requires :provider, type: String
        requires :oauth_token, type: String
      end

      post :authentication do

        provider_info = ClientProvider.new(params[:provider], params[:oauth_token]).get_info

        error!('Unauthorized. Invalid or expired token.', 401) unless provider_info

        user = User.find_or_initialize_by(
          provider: params[:provider],
          provider_id: provider_info[:id]
        )

        new_user_state =
          if user.new_record?
            user.tap do |u|
              u.chat_password = SecureRandom.base64(8)
              u.name = provider_info[:name]
              u.email = provider_info[:email]
              u.avatar = provider_info[:avatar]
            end.save!

            user.sport_type_ids = SportType.ids
          end

        user.generate_token!

        present :user, user, with: Entities::FullUser
        present :new, new_user_state.present?
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

