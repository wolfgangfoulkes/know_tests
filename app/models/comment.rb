class Comment < ActiveRecord::Base
  include Filterable
  include PublicActivity::Common

  belongs_to :root, :polymorphic => true
  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy
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

  def threaded?
    (self.root == self.commentable) && (self.role != "owner")
  end

  def build_comment
    if self.threaded?
      comment = self.comments.build
      comment.commentable = self
      comment.root = self.root
      comment.role = "reply"
      comment
    else
      nil
    end
  end

  def activity_for_save
		a = create_activity key: "comment", trackable: self, owner: self.root, parameters: {role: self.role}
		# owner.updated_at = a.updated_at
  end

end
