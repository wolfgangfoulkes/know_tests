class Questions::CommentsController < CommentsController
	load_and_authorize_resource :question
	load_and_authorize_resource :comment, :through => :question
	before_action :set_commentable

	private
		def set_commentable
			#@commentable = Event.find(params[:event_id])
			@commentable = @question
		end
end