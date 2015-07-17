class ScheduleController < ApplicationController
	before_action :setup, only: [:list]

	def list
		respond_to do |format|
			format.html
			format.json
		end
	end

	def calendar
		respond_to do |format|
			format.html
		end
	end


	private
		def setup
			@user = current_user
			@events = @user.followees(Event) + @user.events
		end
end
