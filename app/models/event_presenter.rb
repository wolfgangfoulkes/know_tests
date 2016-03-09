class EventPresenter 
	def initialize(event = nil)
		@event = event
	end
	
	def method_missing(method)
    	@event.send(method) rescue nil
  	end
end
