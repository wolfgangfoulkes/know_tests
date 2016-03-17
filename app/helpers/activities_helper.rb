module ActivitiesHelper
	def self.pagi(activities, page: 1, per: 10)
		activities.order("created_at DESC").page(page).per(per)
	end
end
