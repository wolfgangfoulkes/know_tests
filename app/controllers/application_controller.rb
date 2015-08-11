class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!

  # modify to set yr own custom error
  rescue_from CanCan::AccessDenied do |exception|
	redirect_to access_error_url
  end
end
