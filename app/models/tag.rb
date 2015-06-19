class Tag < ActiveRecord::Base
	has_many :taggings, dependent: :destroy
	has_many :events, through: :taggings

	validates :name, presence: true
	validates :name, uniqueness: true, if: -> { self.name.present? }
end
