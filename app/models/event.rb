class Event < ActiveRecord::Base
	belongs_to :user
	has_many :taggings, dependent: :destroy
	has_many :tags, through: :taggings

	validates :user_id, presence: true
	#by default the date validator checks for a valid date
	validates :starts_at, presence: true
	validates :ends_at, presence: true
	validates :ends_at, date: { after: :starts_at } 

	after_destroy :remove_orphaned_tags
	after_save :remove_orphaned_tags

	scope :name_starts_with, -> (name) { where("name like ?", "#{name}%") }
	scope :name_contains, -> (name) { where("name like ?", "%#{name}%") }

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
