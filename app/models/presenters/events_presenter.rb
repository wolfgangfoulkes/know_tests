class EventsPresenter
	def initialize(events = nil)
		@events = events
	end

	def method_missing(method, *args, &block)
  	@events.send(method) rescue nil
	end

  def pagi(page: 1, per: 8)
    page(page).per(per)
  end

  def activities_feed
    #self.saved_for
    by_newest_activity.pagi
  end
end