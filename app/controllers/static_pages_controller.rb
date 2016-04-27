class StaticPagesController < ApplicationController
  before_action :set_events, only: [:feed, :saved, :activities]

  def saved
  	@events = @events.saved_for(current_user).deef

    respond_to do |format|
      format.html { 
          render "static_pages/feed" 
      }
      format.js {
          render "static_pages/_feed.js.erb", 
          locals: 
          {
              item_partial: "events/event",
              items: @events
          }
      }
    end

  end

  def feed
    @events = @events.starts_after(DateTime.now.to_date).deef

    respond_to do |format|
      format.html {
          render "static_pages/feed"
      }
      format.js {
          render "static_pages/_feed.js.erb",
          locals: 
          {
              item_partial: "events/event",
              items: @events
          }
      }
    end
  end

  def activities
    @events = @events.where(id: (current_user.followees(Event) | current_user.events)).by_newest_activity

    respond_to do |format|
      format.html { 
          render "static_pages/activities" 
      }
      format.js { 
          render "static_pages/_feed.js.erb",  
          locals: 
          {
              item_partial: "activities/list_short",
              items: @events
          }
      }
    end

  end

  def activity_detail
    event = Event.find(params[:id])
    activities = PublicActivity::Activity.where(owner: event ).order("created_at DESC")

    respond_to do |format|
      format.js { 
          render partial: "activities/detail",
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
      @events = Event.page(1)
      if params[:search]
        @events = @events.search(params[:search])
      end
      if params[:pages]
        @events = @events.pages(params[:pages])
      end
      if params[:page]
        @events = @events.page(params[:page])
      end
    end
end
