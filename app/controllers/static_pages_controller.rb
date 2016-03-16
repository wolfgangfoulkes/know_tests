class StaticPagesController < ApplicationController
  before_action :set_events, only: [:feed, :saved, :activities]

  def saved
  	@events = @events.where(id: (current_user.followees(Event) | current_user.events)).deef

    respond_to do |format|
      format.html { 
          render "static_pages/feed" 
      }
      format.js { 
          render "static_pages/_feed.js.erb", 
          locals: 
          {
              replace: @replace,
              item_partial: "events/event",
              items: @events
          } 
      }
    end

  end

  def feed
    @events = @events.starts_after(DateTime.now).deef

    respond_to do |format|
      format.html { 
          render "static_pages/feed"
      }
      format.js { 
          render "static_pages/_feed.js.erb",
          locals: 
          {
              replace: @replace,
              item_partial: "events/event",
              items: @events
          }
      }
    end
  end

  def activities
    activities = PublicActivity::Activity.where(owner: (current_user.followees(Event) | current_user.events) )
    @events = @events.where(id: activities.order("created_at ASC", "role ASC").pluck("owner_id") )

    respond_to do |format|
      format.html { 
          render "static_pages/activities" 
      }
      format.js { 
          render "static_pages/_feed.js.erb",  
          locals: 
          {
              replace: @replace,
              item_partial: "static_pages/activity_toggle",
              items: @events
          }
      }
    end

  end

  def activity_list
    event = Event.find(params[:id])
    activities = PublicActivity::Activity.where(owner: event ).order("created_at ASC", "role ASC")

    respond_to do |format|
      format.html { 
          render "static_pages/activity_list",
          locals:
          {
              event: event,
              activities: activities
          } 
      }
      format.js { 
          render partial: "static_pages/activity_list", 
          locals: 
          {
              event: event,
              activities: activities
          }
      }
    end

  end

  private

    def set_events
      @events = Event.where(nil)
      @replace = false
      if params.include?(:search)
        @events = @events.search(params[:search])
        @replace = true
      end
      if params.include?(:page)
        @events = EventsHelper.pagi(@events, page: params[:page])
      else
        @events = EventsHelper.pagi(@events, page: 1)
      end
    end
end
