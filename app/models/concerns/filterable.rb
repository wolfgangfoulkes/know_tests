module Filterable
  extend ActiveSupport::Concern

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
    end

    def rel2arel(rel)
      rel.arel.constraints[0] || false
    end
  end
end
