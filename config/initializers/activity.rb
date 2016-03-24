PublicActivity::Activity.class_eval do
	class << self
		def deef
			self.order("created_at DESC")
		end
	end
end