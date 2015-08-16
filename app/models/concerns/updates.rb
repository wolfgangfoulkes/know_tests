module Updates
  extend ActiveSupport::Concern

  included do
    scope :created_after, -> (q) {where("created_at > ?", q)}
  	scope :updated_after, -> (q) {where("updated_at > ?", q)}
  	scope :mod_after, -> (q) { created_after(q) | updated_after(q) }
  end

  def updated?(user)
  	(self.created_at > user.last_sign_in_at) || (self.updated_at > user.last_sign_in_at)
  end

  module ClassMethods

  end
end