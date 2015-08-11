class UsersController < ApplicationController
	load_and_authorize_resource

	def show
		@events = @user.events
	end

	private
    
end
