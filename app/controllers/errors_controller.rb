class ErrorsController < ApplicationController
  def access_error
  end
  
  def not_found
  	render status: 404
  	rescue ActionController::UnknownFormat
    	render status: 404
  end

  def internal_server
  	render status: 500
  end
end
