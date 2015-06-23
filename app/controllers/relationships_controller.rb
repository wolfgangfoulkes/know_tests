class RelationshipsController < ApplicationController

  	def create
      @user = User.find_by(params[:followed_id])
  		current_user.follow(@user)

  		respond_to do |format|
      		format.html { redirect_to @user }
      		format.js
    	end
  	end

  	def destroy
  		@user = current_user.followed_users.find_by(params[:followed_id])
  		current_user.unfollow(params[:followed_id], params[:followed_type])
  		
  		respond_to do |format|
      		format.html { redirect_to @user }
      		format.js
    	end
  	end
end
