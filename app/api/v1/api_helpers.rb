module V1
  module APIHelpers
    def current_user
      @user ||= User.find(params[:user_id])
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

