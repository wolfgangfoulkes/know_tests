class User < ActiveRecord::Base
	has_many :events, dependent: :destroy
	has_many :comments

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable,
	     :omniauthable, :omniauth_providers => [:google_oauth2]


	validates :name, presence: true
	validates :name, uniqueness: true, if: -> { self.name.present? }

	#----- socialization -----
	acts_as_follower
	#-----

	def events_count
		self.events.length
	end

	def comments_count
		self.comments.length
	end
end
