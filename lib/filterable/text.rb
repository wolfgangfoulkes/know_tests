module Filterable
  module Basic
      def self.included(base)
        base.extend ClassMethods 
        base.class_eval do

  # could call this module Text
            cols = columns.select{|a| (a.type == :string) || (a.type == :text) }
            cols.each do |c|
              #-------- class methods --------#
              #- def method_  (return AREL object)
              #- def method   (just like scope, return RELATION)
              #---
              self.class.send :define_method, "#{c.name}_starts_with_" do |q|
                  x_starts_with(c.name, q)
              end
              self.class.send :define_method, "#{c.name}_starts_with" do |q|
                  self.where( x_starts_with(c.name, q) )
              end
              self.class.send :define_method, "#{c.name}_contains_" do |q|
                  x_contains(c.name, q)
              end
              self.class.send :define_method, "#{c.name}_contains" do |q|
                  self.where( x_contains(c.name, q) )
              end
              self.class.send :define_method, "in_#{c.name}_starts_with_" do |q|
                  in_x_starts_with(c.name, q)
              end
              self.class.send :define_method, "in_#{c.name}_starts_with" do |q|
                  self.where( in_x_starts_with(c.name, q) )
              end
            end
          
        end
      end

      
      module ClassMethods
        #----- string pattern matching -----#
        def x_starts_with(x, q)
          self.arel_table[x].matches("#{q.downcase}%")
        end

        def x_contains(x, q)
          self.arel_table[x].matches("%#{q.downcase}%")
        end

        #--- match first letter after word-break
        #-  \m in pgsql is equivalent to \w in regexp. 
        #- the backslash must be escaped of course
        #--
        #
        # #UNSAFE? maybe fine
        def in_x_starts_with(x, q)
          #self.in_name_starts_with(q).arel.constraints.reduce(:and)
          Arel::Nodes::Grouping.new(Arel::Nodes::SqlLiteral.new("#{x} ~* '\\m#{q}'"))
        end
      end


  end
end
