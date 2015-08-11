class AuthorCommentsController < ApplicationController
	load_and_authorize_resource only: [:create, :destroy]
	def create
		respond_to do |format|
			if @author_comment.save
				format.html { redirect_to @author_comment.event }
			else
				format.html { redirect_to root_url }
			end
		end
	end

	def destroy
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
