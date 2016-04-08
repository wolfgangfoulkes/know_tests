module Paginated
  def self.included(base)
    base.extend ClassMethods #this is necc to define ClassMethods below
    base.class_eval do
      @offset = 1
      @limit = 8
    end
  end

  #page(nil) -> OFFSET 0
  #per(nil) -> LIMIT 0
  module ClassMethods
  	def _page
    	self.arel.offset
    end

    def _per
    	self.arel.limit
    end

    def unpaginate
      unscope(:limit, :offset)
    end

    def paginate
    	page(_page).per(_per)
    end

    def collect(page: @offset, per: @limit)
      limit = (page * per) : per
      page(1).per(limit)
    end

    def all_pages
      page(1).per(nil)
    end
  end

end

# Event.page(nil).per(nil)
# Event Load (1.3ms)  SELECT  "events".* FROM "events"  LIMIT 25 OFFSET 0