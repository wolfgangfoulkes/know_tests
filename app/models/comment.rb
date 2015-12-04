class Comment < ActiveRecord::Base
  include Filterable
  include PublicActivity::Common

  belongs_to :root, :polymorphic => true
  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy, before_add: :setup_nested_comment
  has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy

  validate :commentable_valid?
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

  def setup_nested_comment(comment)
    comment.root = self.root
    comment.role = "reply"
  end

  def owner_id
    self.root.user_id
  end

  def owner?(owner)
    (owner.id == self.owner_id)
  end

  def commentable_valid?
    if Comment.can_add_comment_to(commentable)
    else
      errors[:base] << "can't add comment to this model!"
    end
  end

  def self.can_add_comment_to(commentable)
    if commentable.class.name == "Comment"
      commentable.can_add_comment?
    elsif commentable.class.name == "Event"
      true
    else
      false
    end
  end

  def can_add_comment?
    ["default", "public"].include?(self.role)
  end

  def build_comment
    if self.can_comment?
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
