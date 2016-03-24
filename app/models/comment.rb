class Comment < ActiveRecord::Base
  include Filterable
  include PublicActivity::Common

  belongs_to :root, :polymorphic => true
  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  has_many :comments, -> (comment) { where(role: "reply", root: comment.root) },
    as: :commentable,
    dependent: :destroy
    
  has_many :activities, 
    as: :trackable, 
    class_name: 'PublicActivity::Activity',
    dependent: :destroy

  validate :commentable_valid?
  validates :user_id, presence: true
  validates :commentable_id, presence: true
  validates :role, presence: true
  validates :title, presence: true, length: { maximum: 60 }
  validates :comment, presence: true, length: { maximum: 240 }

  # ----- keep this scope
  scope :deef, -> { order("updated_at DESC", "created_at DESC") }

  # ----- simplifies ajax

  scope :freshest_by_commentable, -> { order("created_at DESC", "commentable_id DESC") }
  scope :freshest_by_root, -> { order("created_at DESC", "root_id DESC") }

  # ----
  # -----

# ----- life cycle
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
      throw "bad role for comment"
    end
  end
# -----



# ----- IMPORTANT ----- #
  # ----- fake OOP

  #- unused
  def self.roles
    c = pluck(:role).uniq
  end

  def self.role
    c = pluck(:role).uniq
    if c.size == 1
      "#{c[0]}"
    else
      "" #false
    end
  end


  #- unused?
  def self.collection(roles = nil)
    roles ||= self.pluck(:role).uniq
    Comment.where(role: roles)
  end

  #- unused?
  def collection
    self.commentable.comments.where(role: self.role)
  end



  def owner_id
    self.root.user_id
  end

  def owner
    self.root
  end

  def owner?(owner)
    (owner.id == self.owner_id)
  end
  # -----


# ----- validation ----- #
  # --- validation method
  def commentable_valid?
    if Comment.can_add_comment_to(commentable)
    else
      errors[:base] << "can't add comment to this model!"
    end
  end
  # ---

  # --- used in ^^^
  def self.can_add_comment_to(commentable)
    if commentable.class.name == "Comment"
      commentable.can_add_comment?
    elsif commentable.class.name == "Event"
      true
    else
      false # if a nested comment with role 'default'
    end
  end
  # ---

  # --- used in ^^^
  def can_add_comment? 
    ( ["default"].include?(self.role) ) &&
    ( !self.is_nested? )
  end
  # ---

  # --- used in ^^^
  def is_nested?
    (self.commentable_type == "Comment")
  end
  # ---
# -------- #

# ----- public activity ----- #
  def activity_for_create
    a = create_activity key: "comment", trackable: self, owner: self.root, role: self.role, parameters: {role: self.role}
  end

  def activity_for_save
    #--- right now there's no reason not to use this
    # owner.updated_at = a.updated_at
  end
# ----- #

  # ----- unused currently
  # scope :owner_comments, -> (commentable) { where(role: "owner", root: commentable, root_type: "Event", commentable: commentable, commentable_type: "Event") }
  # scope :default_comments, -> (root) { where(role: "default", root: commentable, root_type: "Event", commentable: commentable, commentable_type: "Event") }
  # scope :private_comments, -> (root) { where(role: "default", public: false, root: commentable, root_type: "Event", commentable: commentable, commentable_type: "Event") }
  # scope :public_comments, -> (root) { where(role: "default", public: true, root: commentable, root_type: "Event", commentable: commentable, commentable_type: "Event") }
  # scope :reply_comments, -> (commentable) { where(role: "default", root: commentable.root, root_type: "Event", commentable_type: "Comment") }
  # 
  # def public_comment?
  #   # actually, replies are also role == "default"
  #   role == "default"             &&
  #   public == true                &&
  #   root == commentable           &&
  #   root_type == "Event"          &&
  #   commentable_type == "Event"   &&
  # end
  #
  # def public_comment?
  #   # actually, replies are also role == "default"
  #   return false unless role == "default"
  #   return false unless public == true
  #   return false unless root == commentable
  #   return false unless root_type == "Event"
  #   return false unless commentable_type == "Event"
  #   return true
  # end
  #
  # def valid_role?
  #   # actually, replies are also role == "default"
  #   if role == "default"
  #     if public == true
  #       if public_comment?
  #         return
  #       end
  #     end
  #     elsif public == false
  #       if private_comment?
  #         return
  #       end
  #     end
  #   end
  #   elsif role == "owner"
  #     if owner_comment?
  #       return
  #     end
  #   end
  # end
  #
  #   errors[:base] << "can't add comment to this model!"
  # end
  # -----
end
