class Comment < ActiveRecord::Base
	belongs_to :commentable, polymorphic: true
	validates :subject, presence: true, length: { maximum: 60 }
	validates :content, presence: true, length: { maximum: 240 }
end
