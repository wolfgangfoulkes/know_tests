class Question < ActiveRecord::Base
	include Filterable
	include Updates
	belongs_to :event
	validates :subject, presence: true, length: { maximum: 60 }
	validates :content, presence: true, length: { maximum: 240 }
	
	has_many :comments, as: :commentable, dependent: :destroy
end
