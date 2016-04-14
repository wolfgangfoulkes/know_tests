class Event < ActiveRecord::Base
	include Filterable
	include Filterable::Time
	include Filterable::Text
	include Taggable
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
	has_many :list_comments, -> (event) { where(role: "default", commentable: event) }, 
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
	has_many :activities, -> { order("created_at DESC") },
		as: :owner, 
		class_name: 'PublicActivity::Activity', 
		dependent: :destroy
#-----#

#----- validations -----
	validates :user_id, presence: true
	validates :name, presence: true
	# by default the date validator checks for a valid date
	validates :starts_at, presence: true
	validates :ends_at, presence: true
	validates :ends_at, date: { after: :starts_at } 
#-----#

#----- callbacks -----
	after_save :remove_orphaned_tags
	after_save(on: :update) do
		# called twice
		# do with 'notify_users checkbox'
	end
	after_destroy :remove_orphaned_tags
#-----#

	# could be a presenter method
	paginates_per 8

	#----- INTERFACE METHODS
	#- for the application's specific uses of the above class methods
	#---
	def self.deef
		self.order("starts_at ASC")
	end

	def self.pagi(page: 1, per: 8, total: 1)
		self.page(page.to_i).per(per.to_i * total.to_i)
	end

	def self.pages(pages=1, per: 8)
		self.page(1).per(per.to_i * pages.to_i)
	end

	def self.to_append(events)
		self.where.not(id: events.select(:id))
	end

	def self.to_remove(events)
		events.where.not(id: self.select(:id))
	end

	def self.saved_for(user)
		followees = Follow.where( follower: user, followable_type: "Event" ).select(:followable_id)
		user_events = user.events.select(:id)
		self.in_any("id", followees, user_events)
	end

	# order determines final order
	# so this is the easiest way to do relevance
	#LOOK INTO AREL JOINS FOR TAGS SEARCH, IT'S A BIT MORE COMPLICATED
	#HOWEVER, WAIT YOU COULD DO IT THROUGH TAGS YEAH!
	def self.search_(q)
		if q.length <= 3
			n = self.arel_table[:name].matches("#{q}%")
			d = nil
			ni = self.in_name_starts_with("#{q}").arel.constraints.reduce(:and)
			di = nil
		elsif q.length <= 5
			n = self.arel_table[:name].matches("#{q}%")
			d = self.arel_table[:description].matches("#{q}%")
			ni = self.in_name_starts_with("#{q}").arel.constraints.reduce(:and)
			di = self.in_description_starts_with("#{q}").arel.constraints.reduce(:and)
		else
			n = self.arel_table[:name].matches_any(["#{q}%", "%#{q}%"])
			d = self.arel_table[:description].matches_any(["#{q}%", "%#{q}%"])
			ni = self.in_name_starts_with("#{q}").arel.constraints.reduce(:and)
			di = self.in_description_starts_with("#{q}").arel.constraints.reduce(:and)
		end
		n.or(ni).or(d).or(di)
	end

	# order determines final order
	def self.search(q)
		self.where( self.search_(q) )
	end
	#-----

#--------#

#----- TAGS 
	def self.tagged_with(name)
		Tag.find_by_name!(name).entries
	end
#-----#

#----- COMMENTS -----#
	def setup_comment(comment)
		comment.setup_params
	end
#-----#

#----- ACTIVITIES
	def self.activities(deef: "created_at DESC")
		PublicActivity::Activity.where(owner_type: 'Event', owner_id: self.all).order(deef)
		#  										  faster -> owner_id: select(:id))
	end

	# Grab events
	# Join them with activities
	# Group by the event ('s id)
	# Now we can use max(activities.created_at) which is the newest activity.created_at for each Event
	# Then sort Events by the most recent activity.created_at in descending order
	# later, perhaps add an optional parameter to change order between DESC and ASC
	def self.by_newest_activity
		self.joins(:activities).group("events.id").order("max(activities.created_at) DESC") 
	end

	def fresh_for(user)
		self.activities.where("created_at > ?", user.last_sign_in_at).order("created_at DESC")
	end

	def fresh_for?(user)
		self.activities.where("created_at > ?", user.last_sign_in_at).any?
	end

	# def fresh_by_type(user)
	# 	f = self.activities.fresh_for(user)
	# 	f.order("activities.role").group("activities.role", "activities.id")
	# end
#-----#



end
