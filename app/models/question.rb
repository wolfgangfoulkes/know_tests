class Question < ActiveRecord::Base
	include Filterable
	belongs_to :event
	validates :subject, presence: true, length: { maximum: 60 }
	validates :content, presence: true, length: { maximum: 240 }
	
	has_many :comments, as: :commentable, dependent: :destroy

	scope :created_after, -> (q) {where("created_at > ?", q)}
	scope :updated_after, -> (q) {where("updated_at > ?", q)}
	scope :mod_after, -> (q) { created_after(q) | updated_after(q) }
end
