class ApplicationController < ActionController::API
  private
    def authenticate_user
      user_token = params['token']
      if user_token
        @user = User.find_by_token(user_token)
        #Unauthorize if a user object is not returned
        if @user.nil?
          return unauthorize
        end
      else
        return unauthorize
      end
    end

    def unauthorize
      render :json => {
        success: false,
        message: "Token Required"
      }
    end
end
