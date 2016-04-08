module EventsHelper
	def self.pagi(events, page: 1, per: 8, total: 1)
		events.page(page).per(per * total)
	end
end
