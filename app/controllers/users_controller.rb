class UsersController < ApplicationController
	before_action :set_user, only: [:show, :follow, :unfollow]

	def show
		@events = @user.events
	end

	def follow
		current_user.follow(@user)
		respond_to do |format|
  			format.html { redirect_to @user }
  			format.js
		end
	end

	def unfollow
		current_user.unfollow(@user)
		respond_to do |format|
  			format.html { redirect_to @user }
  			format.js
		end
	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end
