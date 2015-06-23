class User < ActiveRecord::Base
	has_many :events, dependent: :destroy
	has_many :active_relationships, as: :follower, class_name: 'Relationship'
	# source: allows us to name this differently from "has_many :followeds", source_type allows polymorphic relationships
	has_many :followed_events, through: :active_relationships, source: :followed, source_type: 'Event'
	has_many :followed_users, through: :active_relationships, source: :followed, source_type: 'User'

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable

	validates :name, presence: true
	validates :name, uniqueness: true, if: -> { self.name.present? }

	def follow(thing)
		active_relationships.create(followed_id: thing.id, followed_type: thing.class.name)
	end

	def unfollow(thing)
		relationship = active_relationships.where("followed_id = :thing_id AND followed_type = :thing_type", thing_id: thing.id, thing_type: thing.class.name)
		if !relationship.blank?
			relationship.take.destroy
		end
	end

	def following?(thing)
		!active_relationships.where("followed_id = :thing_id AND followed_type = :thing_type", thing_id: thing.id, thing_type: thing.class.name).blank?
	end
end
