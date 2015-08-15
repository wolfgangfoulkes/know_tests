class User < ActiveRecord::Base
	has_many :events, dependent: :destroy

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

	def updates
		self.followees(Event).find_each.comments + self.self.followees(Event).find_each.questions
	end

	# pass an access object returned by google, 
	# if a user has the email associated with the access object
	# set provider, uid, and token for that user from the object
	def self.find_for_google_oauth2(auth, signed_in_resource=nil)
        data = auth.info
        user = User.find_by(email: data.email)
        if user
            user.provider = auth.provider
            user.uid = auth.uid
            user.token = auth.credentials.token
            user.save
            user
        else 
            redirect_to new_user_registration_path, notice: "Google Error!"
        end
    end
end
