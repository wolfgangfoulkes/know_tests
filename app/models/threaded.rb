module Threaded 

  def self.included(base)
    base.has_many :comments, as: :commentable, dependent: :destroy
  end
 
  def test
    true
  end

  def is_thread?
    true
  end

  def build_comment
    comment = self.comments.build
    comment.commentable = self
    comment.root = self.root
    comment.role = "reply"
    comment
  end

end
