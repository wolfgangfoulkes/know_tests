class StaticPagesController < ApplicationController
  def saved
  	@events = Event.where(id: (current_user.followees(Event) | current_user.events)).page( params[:page] ).per(8).deef

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
    _events = Event.starts_after(DateTime.now).deef

    params[:filter] = _events.where_sql

    # good application of a decorator or something
    @events = EventsHelper.pagi(_events, page: params[:page])

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
    activities = PublicActivity::Activity.where(owner: (current_user.followees(Event) | current_user.events) )
    @events = Event.where(id: activities.order("created_at ASC", "role ASC").pluck("owner_id") ).page( params[:page] ).per(6)

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

  

end
