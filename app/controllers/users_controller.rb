class UsersController < ApplicationController
	before_action :set_user, only: [:show]

	def show
		@events = @user.events
	end

    def find_for_google_oauth2(access_token, signed_in_resource=nil)
        data = access_token.info
        user = User.find_by(email: data.email)
        if user
            user.provider = access_token.provider
            user.uid = access_token.uid
            user.token = access_token.credentials.token
            user.save 
            user
        else 
            redirect_to new_user_registration_path, notice: "Google Error!"
        end
    end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    
end
