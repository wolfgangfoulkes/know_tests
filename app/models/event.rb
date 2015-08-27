class Event < ActiveRecord::Base
	include Filterable
	include PublicActivity::Common
	#----- relationships -----
	#--- socialization
	acts_as_followable
	#-----

	belongs_to :user
	has_many :comments, as: :commentable, dependent: :destroy 
	has_many :questions, dependent: :destroy
	has_many :taggings, dependent: :destroy
	has_many :tags, through: :taggings
	has_many :activities, as: :owner, class_name: 'PublicActivity::Activity', dependent: :destroy
	#--------

	#----- validations -----
	validates :user_id, presence: true
	validates :name, presence: true
	# by default the date validator checks for a valid date
	validates :starts_at, presence: true
	validates :ends_at, presence: true
	validates :ends_at, date: { after: :starts_at } 
	#--------

	#----- scopes ----- 
	# to chain them, I must return an active_record object, and right now
	# that is easiest with "where"
	scope :name_starts_with, -> (q) { where("lower(name) like ?", "#{q.downcase}%") }
	scope :name_contains, -> (q) { where("lower(name) like ?", "%#{q.downcase}%") }
	scope :description_contains, -> (q) { where("lower(description) like ?", "%#{q.downcase}%")}

	scope :time_contains, -> (q) { where("starts_at <= :time AND ends_at >= :time", { time: q }) }

	# order determines final order
	scope :search, -> (q) { where(id: name_starts_with(q) | name_contains(q)) }

	# works with array or relation
	scope :activity_in, -> (q) {
		where(id: q.order("updated_at DESC").map(&:owner_id))
	}

	scope :freshest, -> {
		where(id: all.map{ |i| i.activities.order("updated_at DESC").map(&:owner).last })
	}
	#--------

	#----- callbacks -----
	after_save :remove_orphaned_tags
	after_save(on: :update) do
		# called twice
		# do with 'notify_users checkbox'
	end
	after_destroy :remove_orphaned_tags
	#--------

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
	#-----
	#--- filters

	def self.filter_combine(ps)
		results = []
		ps.each do |p|
			results = results | filter([p])
		end
		results
	end
	#-----
	#--------

end
