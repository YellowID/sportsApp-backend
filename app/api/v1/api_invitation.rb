module V1
  class ApiInvitation < Grape::API
    resource :invitations do
      desc 'Create invitation'

      params do
        requires :user_id, type: Integer
        requires :game_id, type: Integer
      end

      post do
        user = User.find(params[:user_id])
        game = Game.find(params[:game_id])

        game.members << user

        result_success
      end

      desc 'Set state to invitation'

      params do
        requires :user_token, type: String
        requires :game_id, type: Integer
        requires :state, type: Integer
      end

       patch do
         game_member = current_user.game_members.find_by(game_id: params[:game_id])

         case params[:state]
         when 1
           game_member.to_confirmed
         when 2
           game_member.to_possible
         when 3
           game_member.to_rejected
         end

        result_success
      end
    end
  end
end

