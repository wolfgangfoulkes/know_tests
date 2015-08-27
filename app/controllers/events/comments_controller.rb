class Events::CommentsController < CommentsController
	load_and_authorize_resource :event
	load_and_authorize_resource :comment, :through => :event
	before_action :set_commentable

	private
		def set_commentable
			#@commentable = Event.find(params[:event_id])
			@commentable = @event
		end
end