class Comment < ActiveRecord::Base
  include Filterable
  include ActsAsCommentable::Comment
  include PublicActivity::Common

#acts_as_commentable generator
  belongs_to :commentable, :polymorphic => true
  belongs_to :user

#wolfgang
  acts_as_commentable
  has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy

  # validates :user_id, presence: true
  # validates :commentable_id, presence: true
  # role should != "comment"
  # this also returns false for a not-empty string, so you could change the migration to remove default
  validates :role, presence: true
  validates :title, presence: true, length: { maximum: 60 }
  validates :comment, presence: true, length: { maximum: 240 }

  scope :deef, -> { order("updated_at DESC", "created_at DESC") }

  after_save do 
  	activity_for_save
  end

  before_destroy do
  end

  def activity_for_save
		a = create_activity key: "comment", trackable: self, owner: self.commentable, parameters: {role: self.role}
		# owner.updated_at = a.updated_at
  end

end
