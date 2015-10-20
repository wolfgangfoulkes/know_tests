class ScheduleController < ApplicationController
	before_action :setup, only: [:list]
	before_action :set_date, only: [:calendar]

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
			@events = Event.where(id: (@user.followees(Event) | @user.events)).order("starts_at DESC")
		end

		def set_date
			date = params[:date]
			if validDT?(date)
				@date = date.to_s
			else
				@date = false
			end
		end

		# move the following to somewhere public to the app
		def validDT?(dt_)
			(( DateTime.parse(params[:date]) rescue ArgumentError) != ArgumentError)
		end
end
