module Taggable
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      scope :disabled, -> { where(disabled: true) }
    end
  end

  def tag_list=(names)
    # could also use .delete("char")
    self.tags = names.gsub(/\s+/, "").downcase.split(",").uniq.map do |name| 
      Tag.where(name: name).first_or_create!
    end
  end

  def tag_list
    self.tags.map(&:name).join(", ")
  end

  def remove_orphaned_tags
    Tag.all.each do |tag|
      tag.destroy if tag.events.empty?
    end
  end

  module ClassMethods
    # def tagged_with(name)
    #   joins(:tags).where("tags.name LIKE ?", name)
    # end
  end

end
