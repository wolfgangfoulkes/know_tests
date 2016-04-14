module Paginated
  def self.included(base)
    base.extend ClassMethods #this is necc to define ClassMethods below
    base.class_eval do
      scope :disabled, -> { where(disabled: true) }
      @offset = 0
      @limit = 8
      self.ppage = self.class_ppage
      self.pper = self.class_pper
    end
  end

  #page(nil) -> OFFSET 0
  #per(nil) -> LIMIT 0
  module ClassMethods
    attr_accessor :ppage
    attr_accessor :pper
    mattr_accessor :class_ppage
    mattr_accessor :class_pper
    self.class_ppage = 0
    self.class_pper = 8

    # --- utility
  	def offset
    	self.arel.offset
    end

    def limit
    	self.arel.limit
    end

    def unpaginate
      unscope(:limit, :offset)
    end

    def all_pages
      page(1).per(nil)
    end
    # ---

    def poffset
      @offset
    end

    def plimit
      @limit
    end

    def poffset=(offset)
      @offset = offset
    end

    def plimit=(limit)
      @limit = limit
    end

    def set_ppage(page: @offset, per: @limit)
      @offset = page
      @limit = per
      page(page).per(per)
    end

    def set_ppages(page: @offset, per: @limit)
      @offset = page
      @limit = per
      page(page).per(per)
    end

    def ppaged(page: @offset, per: @limit)
    	page(page).per(per)
    end

    def ppagesd(page: @offset, per: @limit)
      limit = (page * per) || per
      page(1).per(limit)
    end

  end
end