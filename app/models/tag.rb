class Tag < ActiveRecord::Base
	include Filterable
	include Filterable::Time
	include Filterable::Text

	has_many :taggings, dependent: :destroy
	has_many :events, through: :taggings

	validates :name, presence: true
	validates :name, uniqueness: true, if: -> { self.name.present? }

	# def self.name_starts_with_(q)
	# 	self.tbl(:name).matches("%#{q}")
	# end

	def self.search_(q)
		if q.length <= 5
			self.name_starts_with_(q)
		else
			self.name_starts_with_(q).or(self.name_contains_(q))
		end
	end

	def self.search(q)
		self.where(self.search_)
	end
end
