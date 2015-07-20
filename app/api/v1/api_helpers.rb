module V1
  module APIHelpers
    def current_user
      @user ||= User.find_by(token: params[:user_token])
    end

    def unauthorized!
      error!('401 Unauthorized', 401)
    end

    def unprocessable_entity!(error)
      error!(error, 422)
    end

    def result_success
      { result: :success }
    end
  end
end

