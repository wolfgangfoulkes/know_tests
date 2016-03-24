class EventPresenter 
	def initialize(event = nil)
		@event = event
	end

	def method_missing(method, *args, &block)
    	@event.send(method) rescue nil
  	end

  	def today?
		@event.starts_at.to_date == Date.today
	end

	def past?
		@event.starts_at <= DateTime.now
	end

	def future?
		@event.starts_at >= DateTime.now
	end
	
  	def self.saved_for(user)
		where(id: ( user.followees(Event) | user.events) ).deef
	end

  	def pagi(page: 1, per: 8)
    	page(page).per(per)
  	end
end


