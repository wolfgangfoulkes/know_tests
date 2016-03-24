module CommentsHelper
	def self.pagi(comments, page: 1, per: 3)
		comments.page(page).per(per)
	end
end
