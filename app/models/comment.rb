class Comment < ActiveRecord::Base
	include PublicActivity::Common
	belongs_to :commentable, polymorphic: true
	validates :subject, presence: true, length: { maximum: 60 }
	validates :content, presence: true, length: { maximum: 240 }

	has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy

	scope :deef, -> { order("updated_at DESC", "created_at DESC") }

	#----- callbacks
	after_save do
		activity_for_save
	end

	before_destroy do
	end

	def activity_for_save
		a = create_activity key: 'comment', trackable: self, owner: self.commentable
		# owner.updated_at = a.updated_at
	end
end
