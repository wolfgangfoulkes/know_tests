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
  def self.s2arel(q)
    Arel::Nodes::SqlLiteral.new(q)
  end

  # def self.s2arel(q)
  #   Arel::Nodes::False.new.or(Arel::Nodes::SqlLiteral.new(q))
  # end

  # hash params are always arel
  def self.and2or_(q)
    # unshift is actually destructive to where_values
    wheres = q.where_values.clone.unshift(Arel::Nodes::False.new)
    wheres.map{ |v| v.class.name == "String" ? self.s2arel(v) : v }.reduce(:or)
  end

  def self.rel2arel(rel)
    # rel.arel.constraints[0] || false
    rel.arel.constraints.reduce(:and) || false
  end

  module ClassMethods
    #--- in: hash of Scopes and Inputs
    #-- out: AR Object combined with AND
    def filter(filtering_params)
      results = self.where(nil)
      filtering_params.each do |key, value|
        results = results.public_send(key, value) if value.present?
      end
      results
    end

    #--- in: hash of Scopes and Inputs
    #-- out: AR Object combined with OR
    def or_filter(filtering_params)
      qs = []
      filtering_params.each do |key, value|
        if value.present?
          qs += self.public_send(key, value).arel.constraints
        end
      end
      self.where(qs.reduce(:or))
      #self.where(self.filter(filtering_params).where_values.reduce(:or))
    end

    #--- in: AR Object combined with AND
    #-- out: Arel query combined with OR
    def and2or_
      Filterable.and2or_(all)
      #self.where(self.filter(filtering_params).where_values.reduce(:or))
      #hash params always arel
    end

    #--- in: AR Object combined with AND
    #-- out: AR Object combined with OR
    def and2or
      # removes scoping first, then reapplies with OR
      unscoped.where( and2or_ )
    end

    #--- in: Hash of params and inputs for 'match'
    #-- out: Arel 'match' query combined with AND
    def all_match_(hash)
      qs = []
      hash.each do |key, value|
        if value.present?
          qs << self.arel_table[key].matches(value)
        end
      end

      qs.reduce(:and)
    end

    #--- in: Hash of params and inputs for 'match'
    #-- out: AR 'match' object combined with AND
    def all_match(hash)
      where(all_match_(hash))
    end

    #--- in: Hash of params and inputs for 'match'
    #-- out: Arel 'match' query combined with OR
    def any_match_(hash)
      qs = []
      hash.each do |key, value|
        if value.present?
          qs << self.arel_table[key].matches(value)
        end
      end

      qs.reduce(:or)
    end

    #--- in: Hash of params and inputs for 'match'
    #-- out: AR 'match' object combined with OR
    def any_match(hash)
      where(any_match_(hash))
    end

    #--- in: variable number of hashes of params and inputs for 'match'
    #-- out: AR 'match' object combined with OR
    def any_of_match(*args)
      qs = []
      args.each do |hash|
        qs << any_match_(hash)
      end
      self.where(qs.reduce(:or))
    end
    # #-----#

    #--- in: variable number of hash, string, or AR inputs (idk about arel)
    #-- out: AR object combined with OR
    def any_of( *queries )
      queries = queries.map do |query|
        query = where( query ) if [ String, Hash ].any? { |type| query.kind_of? type }
        query = where( *query ) if query.kind_of?( Array )
        query.arel.constraints.reduce( :and )
      end

      where( queries.reduce( :or ) )
    end
    # Event.any_of({name: "Bird Party"}, {name: "Blood Orgy", description: "Blood Optional"})
    # Event.any_of({name: "Bird Party"}, "name = 'Blood Orgy' AND description = 'Blood Optional'")
    # ->"events"."name" = 'Bird Party' OR "events"."name" = 'Blood Orgy' AND "events"."description" = 'Blood Optional'
  end
end
