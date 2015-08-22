class Comment < ActiveRecord::Base
	include Updates
	include PublicActivity::Common
	belongs_to :commentable, polymorphic: true
	validates :subject, presence: true, length: { maximum: 60 }
	validates :content, presence: true, length: { maximum: 240 }

	#----- callbacks
	after_save do
		commentable.create_activity key: 'commentable.update_comment', owner: commentable
	end
end
