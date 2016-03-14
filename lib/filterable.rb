module Filterable
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      scope :disabled, -> { where(disabled: true) }
    end
  end

  #----- some arel utility functions originally in Event -----#
  #- I haven't extensively tested them
  #---
  def self.s_to_arel(q)
    Arel::Nodes::SqlLiteral.new(q)
  end
  # for ActiveRecord Relations based on string conditions
  # e.g. Event.where("name ILIKE '%b'")
  def self.q_to_arel(q)
    q.where_values.map{ |v| v.class.name == "String" ? self.s_to_arel(v) : v }.reduce(:or)
  end
  
  def self.to_arel(q)
    if q.class.name == "String"
      self.s_to_arel(q)
    elsif q.class.name == "ActiveRecord::Relation"
      self.q_to_arel(q)
    else
      nil
    end
  end

  def self.rel2arel(rel)
    rel.arel.constraints[0] || false
  end

  module ClassMethods
    def filter(filtering_params)
      results = self.where(nil)
      filtering_params.each do |key, value|
        results = results.public_send(key, value) if value.present?
      end
      results
      
    end

    def ORfilter(filtering_params)
      results = self.where(nil)
      filtering_params.each do |key, value|
        results = results | self.public_send(key, value) if value.present?
      end
      results
      
    end

    def ARORfilter(query)
      self.where( query.where_values.reduce(:or) )
      #self.where(self.filter(filtering_params).where_values.reduce(:or))
      #hash params always arel
    end

    # second part works only with ActiveRecord hash queries or Arel queries:
    # e.g. {name: }
    def hor(q)
      self.where_values.reduce(:or)
    end
    #-----#

  end
end
