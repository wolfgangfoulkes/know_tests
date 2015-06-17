class User < ActiveRecord::Base
	has_many :events, dependent: :destroy

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable

	validates :name, presence: true
	validates :name, uniqueness: true, if: -> { self.name.present? }
end
