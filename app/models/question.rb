class Question < ActiveRecord::Base
	belongs_to :event
	validates :subject, presence: true, length: { maximum: 60 }
	validates :content, presence: true, length: { maximum: 240 }
	
	has_many :comments, as: :commentable, dependent: :destroy

	scope :event_in, -> (q) { where(event: q) }
end
