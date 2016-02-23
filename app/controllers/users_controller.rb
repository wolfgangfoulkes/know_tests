class UsersController < ApplicationController
	load_and_authorize_resource

	def show
		@events = @user.events.page( params[:page] ).per(8)
		respond_to do |format|
      	  format.html 
	      format.js {
	        render "shared/paginate.js.erb", locals: {target: "events", content: @events.page(params[:page]).per(2) }
	      }
	    end
	end

	private
    
end
