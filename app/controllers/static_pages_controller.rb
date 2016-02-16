class StaticPagesController < ApplicationController
  def saved
  	@events = Event.where(id: (current_user.followees(Event) | current_user.events)).page( params[:page] ).per(6).deef
    render :feed
  end

  def feed
    @events = Event.where("starts_at >= ?", DateTime.now).page( params[:page] ).per(6).deef
    render :feed
  end

  def activities
    activities = PublicActivity::Activity.where(owner: (current_user.followees(Event) | current_user.events) )
    @events = Event.where(id: activities.order("created_at DESC").pluck("owner_id") )
  end
end
