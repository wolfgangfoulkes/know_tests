class Question < ActiveRecord::Base
	include Filterable
	include PublicActivity::Common
	belongs_to :event
	validates :subject, presence: true, length: { maximum: 60 }
	validates :content, presence: true, length: { maximum: 240 }
	
	has_many :comments, as: :commentable, dependent: :destroy

	#----- callbacks
	after_save do
		activity_for_save
	end

	def activity_for_save
		event.create_activity key: 'event.update_question', owner: event
	end
end
