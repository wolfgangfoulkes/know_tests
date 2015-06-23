class StaticPagesController < ApplicationController
  def home
  	@user = current_user
  	@events = Event.all
  	@event = @user.events.build
  end

  def schedule
  	@user = current_user
  	@events = @user.events
  end
end
