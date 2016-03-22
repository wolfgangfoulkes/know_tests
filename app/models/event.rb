class Event < ActiveRecord::Base
	include Filterable
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

#----- scopes ----- 
	scope :deef, -> { order("starts_at ASC") }
#-----#

#-------- class methods --------#
#- def method_ 	(return AREL object)
#- def method 	(just like scope, return RELATION)
#---
	#----- time
	def self.starts_after_(q)
		self.arel_table[:starts_at].gt(q)
	end
	def self.starts_after(q)
		self.where(self.starts_after_(q))
	end
	def starts_after?(q)
		self.starts_at > q
	end

	def self.starts_between_(l, h)
		tbl = self.arel_table
		ll = tbl[:starts_at].gt(l)
		hh = tbl[:starts_at].lt(h)
		ss.and(hh)
	end
	def self.starts_between(l, h)
		self.where( self.starts_between_(l, h) )
	end

	# def self.starts_between_(l, h)
	# 	self.where(starts_at: l..h) #arel where values
	# end

	def self.ends_in_(l, h)
		tbl = Event.arel_table
		ll = tbl[:ends_at].gt(l)
		hh = tbl[:ends_at].lt(h)
		ss.and(hh)
	end
	def self.ends_in(l, h)
		self.where( self.ends_in_(l, h) )
	end

	def self.overlaps_(l, h)
		tbl = self.arel_table
		si = self.starts_between_(l, h)
		ei = self.ends_in_(l, h)
		si.or(ei)
	end
	def self.overlaps(l, h)
		self.where( self.starts_between_(l, h) )
	end
	def overlaps?(l, h)
		sa = (self.starts_at > l && self.starts_at < h)
		ea = (self.ends_at > l && self.ends_at < h)
		sa && ea
	end

	def self.time_contains_(q)
		tbl = self.arel_table
		sa = tbl[:starts_at].lteq(q)
		ea = tbl[:ends_at].gteq(q)
		sa.and(ea)
	end
	def self.time_contains(q)
		self.where( self.time_contains_(q) )
	end
	def time_contains?(q)
		sa = self.starts_at >= q
		ea = self.ends_at <= q
	end

	#----- string pattern matching -----#
	def self.name_starts_with_(q)
		self.arel_table[:name].matches("#{q.downcase}%")
	end
	def self.name_starts_with(q)
		self.where( self.name_starts_with_(q) )
	end

	def self.name_contains_(q)
		self.arel_table[:name].matches("%#{q.downcase}%")
	end
	def self.name_contains(q)
		self.where( self.name_contains_(q) )
	end

	def self.description_starts_with_(q)
		self.arel_table[:description].matches("#{q.downcase}%")
	end
	def self.description_starts_with(q)
		self.where( self.description_starts_with_(q) )
	end

	def self.description_contains_(q)
		self.arel_table[:description].matches("%#{q.downcase}%")
	end
	def self.description_contains(q)
		self.where( self.description_contains_(q) )
	end

	def self.match_any_(k, vs)
		#Arel::Nodes::SqlLiteral.new()
		self.match_any(k, vs).where_sql
	end
	def self.match_any(k, vs)
		self.where( "#{k} ilike any (array[?])", vs )
	end

	#--- match first letter after word-break
	#-	\m in pgsql is equivalent to \w in regexp. 
	#- the backslash must be escaped of course
	#--
	#
	def self.in_name_starts_with(q)
		self.where("name ~* ?", "\\m#{q}")
	end
	def self.in_name_starts_with_(q)
		# arel sql literal: Arel.sql(self.in_name_starts_with(q.to_s).where_values.reduce(:&))
		self.in_name_starts_with("#{q}").arel.constraints.reduce(:and)
	end
	def self.in_description_starts_with(q)
		self.where("description ~* ?", "\\m#{q}")
	end
	def self.in_description_starts_with_(q)
		# arel sql literal: Arel.sql(self.in_description_starts_with(q.to_s).where_values.reduce(:&))
		self.in_description_starts_with("#{q}").arel.constraints.reduce(:and)
	end
	#----- metaprogramming alts
	#		[:name, :description].each do |p|
	#			self.class.send :define_method, "in_#{p}_starts_with" do |q|
	#				self.where("#{p} ~* ?", "\\m#{q}")
	#			end
	#			self.class.send :define_method, "in_#{p}_starts_with" do |q|
	#				self.where("#{self.arel_table[p].name} ~* ?", "\\m#{q}")
	#			end
	#		  self.class.send :define_method, "in_#{p}_starts_with" do |q|
	#				self.where("#{self.arel_table[p].name} ~* ?", "\\m#{q}")
	#			end
	#		  self.class.send :define_method, "in_#{p}_starts_with_" do |q|
	#				self.where("#{p} ~* ?", "\\m#{q}").where_sql
	#			end
	#		end
	#
	# 		get all string/text columns to perform above
	# 		a = []
	# 		self.columns.each do |c|
	# 			a << c if c.type == :string || c.type == :text
	# 		end
	#-----

	#----- INTERFACE METHODS
	#- for the application's specific uses of the above class methods
	#---

	# prev search version using sql literals for some values
	#
	# def self.search_(q)
	# 	if q.length <= 3
	# 		n = self.arel_table[:name].matches("#{q}%")
	# 		d = nil
	# 		ni = Arel.sql( self.in_name_starts_with("#{q}").where_values.reduce(:&) )
	# 		di = nil
	# 	elsif q.length <= 5
	# 		n = self.arel_table[:name].matches("#{q}%")
	# 		d = self.arel_table[:description].matches("#{q}%")
	# 		ni = Arel.sql( self.in_name_starts_with("#{q}").where_values.reduce(:&) )
	# 		di = Arel.sql( self.in_description_starts_with("#{q}").where_values.reduce(:&) )
	# 	else
	# 		n = self.arel_table[:name].matches_any(["#{q}%", "%#{q}%"])
	# 		d = self.arel_table[:description].matches_any(["#{q}%", "%#{q}%"])
	# 		ni = Arel.sql( self.in_name_starts_with("#{q}").where_values.reduce(:&) )
	# 		di = Arel.sql( self.in_description_starts_with("#{q}").where_values.reduce(:&) )
	# 	end
	# 	n.or(d).or(ni).or(di) 	# ni and di must follow n or d
	# 	#n.or(ni).or(d).or(di)
	# end

	# order determines final order
	# so this is the easiest way to do relevance
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

	# Grab events
	# Join them with activities
	# Group by the event ('s id)
	# Now we can use max(activities.created_at) which is the newest activity.created_at for each Event
	# Then sort Events by the most recent activity.created_at in descending order
	# later, perhaps add an optional parameter to change order between DESC and ASC
	def self.by_newest_activity
		self.joins(:activities).group("events.id").order("max(activities.created_at) DESC") 
	end
	
	#---
#-----#

#----- TAGS 
	def self.tagged_with(name)
		Tag.find_by_name!(name).entries
	end

	# def tag_list=(names)
	# 	# could also use .delete("char")
	# 	self.tags = names.gsub(/\s+/, "").downcase.split(",").uniq.map do |name| 
	# 		Tag.where(name: name).first_or_create!
	# 	end
	# end

	# def tag_list
	# 	self.tags.map(&:name).join(", ")
	# end

	# def remove_orphaned_tags
	#   Tag.all.each do |tag|
	#     tag.destroy if tag.events.empty?
	#   end
	# end
#-----#

end
