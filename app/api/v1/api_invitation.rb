module V1
  module Entities
    class Invitation < Grape::Entity
      expose(:id, documentation: { type: 'integer' })
      expose(:user, using: Entities::User)
      expose(:game, using: Entities::Game)
      expose(:owner, using: Entities::User)
    end
  end

  class ApiInvitation < Grape::API
    resource :invitations do
      params do
        requires :user_token, type: String
      end

      desc 'Get invitation list'

      get do
        invitations = current_user.invitations

        present invitations, with: Entities::Invitation
      end

      route_param :id do
        desc 'Confirm invitation'

        post do
          invitation = current_user.invitations.find(params[:id])
          ActiveRecord::Base.transaction do
            current_user.participate_games << invitation.game
            invitation.confirm!
          end

          result_success
        end
      end
    end

    resource :owned_invitations do
      params do
        requires :user_token, type: String
      end

      desc 'Get invitation list'

      get do
        invitations = current_user.post_invitations

        present invitations, with: Entities::Invitation
      end

      desc 'Create invitation'

      params do
        requires :user_id, type: Integer
        requires :game_id, type: Integer
      end

      post do
        post_invitation = current_user.post_invitations.create!(
          user_id: params[:user_id],
          game_id: params[:game_id])

        present post_invitation, with: Entities::Invitation
      end

      route_param :id do
        desc 'Delete'

        delete do
          invitation = current_user.post_invitations.find(params[:id])

          invitation.destroy!

          result_success
        end
      end
    end

  end
end

