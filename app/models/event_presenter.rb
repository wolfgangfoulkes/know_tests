class EventPresenter 
	def initialize(event = nil)
		@event = event
	end

	def today?
		@event.starts_at.to_date == Date.today
	end

	def past?
		@event.starts_at <= DateTime.now
	end
	
	def method_missing(method)
    	@event.send(method) rescue nil
  	end
end
