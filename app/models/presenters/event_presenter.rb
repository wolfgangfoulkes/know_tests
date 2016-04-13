class EventPresenter 
	def initialize(event = nil)
		@event = event
	end

	def method_missing(method, *args, &block)
    	@event.send(method) rescue nil
  	end

  	def pagi(page: 1, per: 8)
    	page(page).per(per)
  	end

	def fresh_for(user)
		@event.activities.where("created_at > ?", user.last_sign_in_at).order("created_at DESC")
	end

	def fresh_for?(user)
		@event.activities.where("created_at > ?", user.last_sign_in_at).any?
	end
end


