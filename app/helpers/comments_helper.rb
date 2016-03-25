module CommentsHelper
	def self.pagi(comments, page: 1, per: 6)
		comments.page(page).per(per)
	end
end
