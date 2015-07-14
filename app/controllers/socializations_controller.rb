class SocializationsController < ApplicationController
  before_filter :load_socializable

  def follow
    current_user.follow!(@socializable)
    respond_to do |format|
    	format.js { render 'follow_button.js.erb', locals: {socializable: @socializable} }
    end
  end

  def unfollow
    current_user.unfollow!(@socializable)
    respond_to do |format|
    	format.js { render 'follow_button.js.erb', locals: {socializable: @socializable} }
    end
  end

private
  def load_socializable
    @socializable =
      case
      when id = params[:event_id]
        Event.find(id)
      else
        raise ArgumentError, "Unsupported socializable model, params: " + params.keys.inspect
      end
    raise ActiveRecord::RecordNotFound unless @socializable
  end  
end