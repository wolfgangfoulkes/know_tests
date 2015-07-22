class Event < ActiveRecord::Base
	include Filterable
	#----- relationships
	belongs_to :user
	has_many :taggings, dependent: :destroy
	has_many :tags, through: :taggings
	#-----

	#----- validations -----
	validates :user_id, presence: true
	# by default the date validator checks for a valid date
	validates :starts_at, presence: true
	validates :ends_at, presence: true
	validates :ends_at, date: { after: :starts_at } 
	#-----

	#----- scopes ----- 
	scope :name_starts_with, -> (q) { where("lower(name) like ?", "#{q.downcase}%") }
	scope :name_contains, -> (q) { where("lower(name) like ?", "%#{q.downcase}%") }
	scope :description_contains, -> (q) { where("lower(description) like ?", "%#{q.downcase}%")}

	scope :time_contains, -> (q) { where("starts_at <= :time AND ends_at >= :time", { time: q }) }
	# order determines final order
	scope :search, -> (q) { name_starts_with(q) | name_contains(q) }

	def self.default_scope
		order("starts_at ASC")
	end
	#-----

	#----- socialization -----
	acts_as_followable
	#-----

	#----- callbacks -----
	after_destroy :remove_orphaned_tags
	after_save :remove_orphaned_tags
	#-----



	#----- METHODS -----
	
	#--- tags 
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
	#---

	def self.filter_combine(ps)
		results = []
		ps.each do |p|
			results = results | filter([p])
		end
		results
	end

	#-----


end
