module ViewUtility
  def self.included(base)
    base.extend ClassMethods #this is necc to define ClassMethods below
    base.class_eval do
    end
  end
  module ClassMethods
  end

  

end
