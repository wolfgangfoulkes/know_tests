module ActivitiesHelper
	def self.pagi(activities, page: 1, per: 10)
		activities.page(page).per(per)
	end
end
