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
              item_partial: "static_pages/activity_toggle",
              items: @events
          }
      }
    end

  end

  def activity_list
    event = Event.find(params[:id])
    activities = PublicActivity::Activity.where(owner: event ).order("created_at DESC")

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
      @events = Event.page(1)
      if params[:search]
        @events = @events.search(params[:search])
      end
      if params[:page]
        @events = @events.page(params[:page])
      end
      if params[:pages]
        @events = @events.page(params[:pages])
      end
    end

    def filtering_params
      params.permit(:search, :page, :pages, :per)
    end
end
