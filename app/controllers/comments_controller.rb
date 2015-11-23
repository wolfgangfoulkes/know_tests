class CommentsController < ApplicationController
	load_and_authorize_resource

	def create
		respond_to do |format|
			if @comment.save
				format.html { redirect_to @comment.commentable }
			else
				format.html { redirect_to @comment.commentable, notice: @comment.errors.full_messages.join(", ") }
			end
		end
	end

	def destroy
		@comment.destroy
		respond_to do |format|
			format.html { redirect_to @comment.commentable }
		end
	end

	def show
	end

	def set_public
		authorize! :set_public, @comment
		@comment.role = "public"
		respond_to do |format|
			format.html { redirect_to @comment.commentable }
		end
	end

	def set_default
		authorize! :set_default, @comment
		@comment.role = "default"
		redirect_to @comment.commentable
		respond_to do |format|
			format.html { redirect_to @comment.commentable }
		end
	end

	private
		def comment_params
			params.require(:comment).permit(:commentable_id, :commentable_type, :role, :user_id, :title, :comment)
		end
end
