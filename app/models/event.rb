class Event < ActiveRecord::Base
	belongs_to :user
	has_many :taggings, dependent: :destroy
	has_many :tags, through: :taggings, foreign_key: :tag_id, dependent: :destroy

	validates :user_id, presence: true

	after_destroy :remove_orphaned_tags

	def tag_list=(names)
		# could also use .delete("char")
		self.tags = names.gsub(/\s+/, "").downcase.split(",").uniq.map do |name| 
			Tag.where(name: name).first_or_create!
		end
	end

	def tag_list
		self.tags.map(&:name).join(", ")
	end

	def self.tagged_with(name)
		Tag.find_by_name!(name).entries
	end

	def remove_orphaned_tags
	  Tag.all.each do |tag|
	    tag.destroy if tag.events.empty?
	  end
	end
end
