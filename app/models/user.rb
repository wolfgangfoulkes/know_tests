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

	def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
        data = access_token.info
        user = User.find_by(email: data.email)
        if user
            user.provider = access_token.provider
            user.uid = access_token.uid
            user.token = access_token.credentials.token
            user.save 
            user
        else 
            redirect_to new_user_registration_path, notice: "Google Error!"
        end
    end
end
