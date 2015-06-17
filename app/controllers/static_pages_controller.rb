class StaticPagesController < ApplicationController
  def home
  	@user = current_user
  	@events = Event.all
  	@event = @user.events.build
  end
end
