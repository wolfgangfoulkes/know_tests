class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def google_oauth2
	    @auth = request.env["omniauth.auth"]["credentials"]
	    if @auth.refresh_token
		    Token.create(
		    	email: current_user.email,
		    	access_token: @auth['token'],
		    	refresh_token: @auth['refresh_token'],
		    	expires_at: Time.at(@auth['expires_at']).to_datetime
		    )
		    redirect_to current_user
		else
			redirect_to root_url
		end
  	end
	
end
