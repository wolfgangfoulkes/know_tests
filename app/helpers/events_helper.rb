module EventsHelper
	def self.pagi(events, page: 1, per: 8)
		events.page(page).per(per)
	end
end
