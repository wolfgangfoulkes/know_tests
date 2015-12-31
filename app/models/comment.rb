class Comment < ActiveRecord::Base
  include Filterable
  include PublicActivity::Common

  belongs_to :root, :polymorphic => true
  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  has_many :comments, -> (comment) { where(role: "reply", root: comment.root) }, 
    as: :commentable,
    dependent: :destroy
  has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy

  validate :commentable_valid?
  validates :user_id, presence: true
  validates :commentable_id, presence: true
  validates :role, presence: true
  validates :title, presence: true, length: { maximum: 60 }
  validates :comment, presence: true, length: { maximum: 240 }

  scope :deef, -> { order("updated_at DESC", "created_at DESC") }

  # ----- simplifies ajax
  scope :same_type?, ->  { (pluck(:role).uniq.size == 1) }
  scope :type, -> { 
    c = pluck(:role).uniq
    if c.size == 1
      "#{c[0]}_comments"
    else
      "comments"
    end
  }
  scope :collection, -> (role) {
    where(role: role)
  }
  def type
    "#{self.role}_comments"
  end
  def collection
    self.commentable.comments.where(role: self.role)
  end
  # -----
  
  # unused currently
  # scope :owner_comments, -> (commentable) { where(role: "owner", root: commentable, root_type: "Event", commentable: commentable, commentable_type: "Event") }
  # scope :default_comments, -> (root) { where(role: "default", root: commentable, root_type: "Event", commentable: commentable, commentable_type: "Event") }
  # scope :public_comments, -> (root) { where(role: "public", root: commentable, root_type: "Event", commentable: commentable, commentable_type: "Event") }
  # scope :reply_comments, -> (commentable) { where(role: "owner", root: commentable.root, root_type: "Event", commentable_type: "Comment") }

  after_create do
    setup_params
    activity_for_create
  end

  after_save do 
  	activity_for_save
  end

  before_destroy do
  end

  def setup_params
    if self.role == "default"
      self.commentable = self.root
    elsif self.role == "owner"
      self.public = true
      self.commentable = self.root
    elsif self.role == "reply"
      self.public = true
      self.root = self.commentable.root
    else
      throw "bad role"
    end
  end

  def is_nested?
    (self.commentable_type == "Comment")
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
    ( ["default"].include?(self.role) ) &&
    ( !self.is_nested? )
  end

  # ----- public activity
  def activity_for_create
    a = create_activity key: "comment", trackable: self, owner: self.root, parameters: {role: self.role}
  end

  def activity_for_save
    # owner.updated_at = a.updated_at
  end
  # -----

end
