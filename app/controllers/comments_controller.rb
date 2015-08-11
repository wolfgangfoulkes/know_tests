class CommentsController < ApplicationController
	def create
		#@comment.user = current_user
		respond_to do |format|
			if @comment.save
				format.html { redirect_to @commentable }
			else
				format.html { redirect_to @commentable }
			end
		end
	end

	def destroy
		@comment.destroy
		respond_to do |format|
			format.html { redirect_to @comment.commentable }
		end
	end

	private
		def comment_params
			params.require(:comment).permit(:subject, :content)
		end
end
