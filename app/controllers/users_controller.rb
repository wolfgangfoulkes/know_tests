class UsersController < ApplicationController
	before_action :set_user, only: [:show]

	def show
		@events = @user.events
	end

	def follow(thing)
		active_relationships.create(followed_id: thing.id, followed_type: thing.class.name)
	end

	def following?(thing)
		active_relationships.where("followed_id = :thing_id AND followed_type = :thing_type", thing.id, thing.class.name).blank?
	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end
