class Comment < ActiveRecord::Base
	include PublicActivity::Common
	belongs_to :commentable, polymorphic: true
	validates :subject, presence: true, length: { maximum: 60 }
	validates :content, presence: true, length: { maximum: 240 }

	#----- callbacks
	after_save do
		activity_for_save
	end

	def activity_for_save
		commentable.create_activity key: 'commentable.update_comment', owner: commentable
	end
end
