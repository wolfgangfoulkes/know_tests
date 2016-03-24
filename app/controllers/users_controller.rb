class UsersController < ApplicationController
	load_and_authorize_resource

	def show
		@events = @user.events
		respond_to do |format|
      	  format.html 
	    end
	end

	private
    
end
