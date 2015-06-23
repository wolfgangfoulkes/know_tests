class Relationship < ActiveRecord::Base
	belongs_to :follower, polymorphic: true
	belongs_to :followed, polymorphic: true
end
