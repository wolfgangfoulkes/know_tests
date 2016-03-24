module Filterable
  module Basic
      def self.included(base)
        base.extend ClassMethods 
        base.class_eval do
  # could call this module Text
            cols = columns.select{|a| (a.type == :string) || (a.type == :text) }
            cols.each do |c|

              self.class.send :define_method, "in_#{c.name}_starts_with_" do |q|
                  in_x_starts_with(c, q)
              end
              self.class.send :define_method, "in_#{c.name}_starts_with" do |q|
                  self.where( in_x_starts_with(c, q) )
              end
            end
          
        end
      end

      
      module ClassMethods
        def in_x_starts_with(x, q)
          Arel::Nodes::Grouping.new(Arel::Nodes::SqlLiteral.new("#{x.name} ~* '\\m#{q}'"))
        end

        def x_starts_with(x, q)
          self.arel_table[x].matches("#{q.downcase}%")
        end

        def x_contains_(x, q)
          self.arel_table[x].matches("%#{q.downcase}%")
        end
      end
  end
end
