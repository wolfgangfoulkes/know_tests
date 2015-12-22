class Event < ActiveRecord::Base
	include Filterable
	include PublicActivity::Common
	#----- relationships -----
	#--- socialization
	acts_as_followable
	#-----
	
	has_many :comments, as: :root, dependent: :destroy
	has_many :owner_comments, -> (event) { where(role: "owner", commentable: event) }, 
		class_name: "Comment", 
		as: :root,
		dependent: :destroy,
		after_add: :setup_comment
	has_many :feed_comments, -> (event) { where(role: "default", commentable: event) }, 
		class_name: "Comment", 
		as: :root,
		dependent: :destroy
	has_many :reply_comments, -> (event) { where(role: "reply", commentable_type: "Comment") }, 
		class_name: "Comment",
		as: :root,
		dependent: :destroy

	belongs_to :user
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
	scope :deef, -> { order("starts_at ASC") }

	scope :name_starts_with, -> (q) { where("lower(name) like ?", "#{q.downcase}%") }
	scope :name_contains, -> (q) { where("lower(name) like ?", "%#{q.downcase}%") }
	scope :description_starts_with, -> (q) { where("lower(description) like ?", "#{q.downcase}%")}
	scope :description_contains, -> (q) { where("lower(description) like ?", "%#{q.downcase}%")}

	scope :starts_after, -> (q) { where("starts_at >= ?", q ) }
	scope :time_contains, -> (q) { where("starts_at <= :time AND ends_at >= :time", { time: q }) }

	# order determines final order
	scope :search, -> (q) {
		if q.size > 3 
			where(id: name_starts_with(q) | description_starts_with(q) | name_contains(q) |  description_contains(q))
		else
			where(id: name_starts_with(q) | description_starts_with(q))
		end
	}

	# works with array or relation
	# does not retain activities order
	scope :activity_in, -> (q) {
		where(id: q.select(:owner_id))
	}

	scope :freshest, -> {
		all
		#following don't work
		#includes(:activities).order("activities.updated_at DESC")
		#joins(:activities).order("activities.updated_at DESC")
	}

	scope :activities, -> {
		PublicActivity::Activity.where(owner_type: 'Event', owner_id: all)
		#  										  faster -> owner_id: select(:id))
	}

	# NOTE TO WOLFGANG: if you come back here, 
	# learn find_each do
	# see how it returns


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

	def setup_comment(comment)
		if comment.role == "owner"
			comment.public = true
		end
	end

	#--- activities
	def fresh_for(user)
		self.activities.where("updated_at > ?", user.last_sign_in_at).order("updated_at DESC")
	end

	def fresh_for?(user)
		self.activities.where("updated_at > ?", user.last_sign_in_at).any?
	end
	#-----

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
