module Filterable
  module Time
      # def included(base)
      #   base.extend ClassMethods
      #   base.class_eval do
      #   end
      # end

      def overlaps?(l, h)
          sa = (self.starts_at > l && self.starts_at < h)
          ea = (self.ends_at > l && self.ends_at < h)
          sa && ea
      end

      def time_contains?(q)
        sa = self.starts_at >= q
        ea = self.ends_at <= q
      end

      def starts_after?(q)
          self.starts_at > q
      end

      def today?
        self.starts_at.to_date == Date.today
      end

      def past?
        self.starts_at < DateTime.now
      end

      def upcoming?
        self.starts_at > DateTime.now
      end

      # examples
      #
      # def after_today?
      #   !self.today? && self.past?
      # end

      # def before_today?
      #   !self.today? && self.upcoming?
      # end

      # def earlier_today?
      #   self.today? && self.past?
      # end

      # def later_today?
      #   self.today? && self.upcoming?
      # end

      module ClassMethods
          def starts_after_(q)
            self.arel_table[:starts_at].gt(q)
          end
          def starts_after(q)
            self.where(self.starts_after_(q))
          end
        
          def starts_between_(l, h)
            tbl = self.arel_table
            ll = tbl[:starts_at].gt(l)
            hh = tbl[:starts_at].lt(h)
            ss.and(hh)
          end
          def starts_between(l, h)
            self.where( self.starts_between_(l, h) )
          end

          # def starts_between_(l, h)
          #   self.where(starts_at: l..h) #arel where values
          # end

          def ends_in_(l, h)
            tbl = Event.arel_table
            ll = tbl[:ends_at].gt(l)
            hh = tbl[:ends_at].lt(h)
            ss.and(hh)
          end
          def ends_in(l, h)
            self.where( self.ends_in_(l, h) )
          end

          def overlaps_(l, h)
            tbl = self.arel_table
            si = self.starts_between_(l, h)
            ei = self.ends_in_(l, h)
            si.or(ei)
          end
          def overlaps(l, h)
            self.where( self.starts_between_(l, h) )
          end

          def time_contains_(q)
            tbl = self.arel_table
            sa = tbl[:starts_at].lteq(q)
            ea = tbl[:ends_at].gteq(q)
            sa.and(ea)
          end
          def time_contains(q)
            self.where( self.time_contains_(q) )
          end
        
      end
  end
end
