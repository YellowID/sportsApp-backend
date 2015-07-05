module V1
  module Entities
    class User < Grape::Entity
      expose(:id, documentation: { type: 'integer' })
      expose(:provider, documentation: { type: 'string' })
      expose(:oauth_token, documentation: { type: 'string' })
      expose(:email, documentation: { type: 'string' })
      expose(:name, documentation: { type: 'string' })
      expose(:chat_password, documentation: { type: 'string' })
    end
  end

  class ApiUsers < Grape::API
    resource :users do
      desc 'Authenticate user'

      params do
        optional :name, type: String
        optional :email, type: String
        requires :oauth_token, type: String
        requires :provider, type: String
      end

      post :authentication do
        user = User.find_or_initialize_by(
          provider: params[:provider],
          oauth_token: params[:oauth_token]
        )

        unless user.persisted?
          user.tap do |u|
            u.chat_password = SecureRandom.base64(8)
            u.name = params[:name]
            u.email = params[:email]
          end.save!
        end

        present user, with: Entities::User
      end
    end
  end
end

