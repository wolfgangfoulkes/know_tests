class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!

  # helper methods can be accessed in the view
  helper_method :fresh?
  helper_method :fresh!

  # modify to set yr own custom error
  rescue_from CanCan::AccessDenied do |exception|
	 redirect_to access_error_url
  end

  # delicious? 
  def fresh?(o_)
  	ApplicationHelper.fresh_for_user?(o_, current_user)
  end # ----- used here and in comment and activity view

  # delicious! 
  def fresh!(collection_)
    collection_.find_all {|i| i if fresh?(i)}
  end # ----- unused

end 
