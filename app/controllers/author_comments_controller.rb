class AuthorCommentsController < ApplicationController
	def create
		@author_comment = AuthorComment.new(author_comment_params)
		respond_to do |format|
			if @author_comment.save
				format.html { redirect_to @author_comment.event }
			else
				format.html { redirect_to root_url }
			end
		end
	end

	def destroy
		@author_comment = AuthorComment.find(params[:id])
		@author_comment.destroy
		respond_to do |format|
			format.html { redirect_to root_url }
		end
	end

	private
		def author_comment_params
			params.require(:author_comment).permit(:event_id, :subject, :content)
		end
end
