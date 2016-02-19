class StaticPagesController < ApplicationController
  def saved
  	@events = Event.where(id: (current_user.followees(Event) | current_user.events)).page( params[:page] ).per(8).deef

    respond_to do |format|
      format.html { render :feed }
      format.js { 
        render "static_pages/_feed.js.erb", locals: {item_partial: "events/event", items: @events} 
      }
    end

  end

  def feed
    @events = Event.where("starts_at >= ?", DateTime.now).page( params[:page] ).per(8).deef

    respond_to do |format|
      format.html { render :feed }
      format.js { 
        render "static_pages/_feed.js.erb", locals: {item_partial: "events/event", items: @events}
      }
    end
  end

  def activities
    activities = PublicActivity::Activity.where(owner: (current_user.followees(Event) | current_user.events) )
    @events = Event.where(id: activities.order("created_at DESC").pluck("owner_id") ).page( params[:page] ).per(6)

    respond_to do |format|
      format.html { render :activities }
      format.js { 
        render "static_pages/_feed.js.erb", locals: {item_partial: "events/activities", items: @events}
      }
    end

  end

end
