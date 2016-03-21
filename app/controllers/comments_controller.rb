class CommentsController < ApplicationController
	load_resource :only => [:create, :destroy, :set_public, :set_default, :show]
	authorize_resource :only => [:create, :destroy, :show]
	before_action :set_collection, only: [:create, :destroy, :set_public, :set_default]
	

	def create
		respond_to do |format|
			if @comment.save
				format.html { redirect_to @comment.commentable }
				format.js {
					render "shared/refresh.js.erb", locals: {target: @comment.role, content: @comments.deef }
				}
			else
				format.html { redirect_to @comment.commentable, notice: @comment.errors.full_messages.join(", ") }
			end
		end
	end

	def destroy
		@comment.destroy
		respond_to do |format|
			format.html { redirect_to @comment.commentable }
			format.js {
				render "shared/refresh.js.erb", locals: {target: params[:refresh], content: @comments.deef }
			}
		end
	end


	def show
	end

	def set_public
		authorize! :set_public, @comment
		@comment.public = true
		respond_to do |format|
			if @comment.save
				format.html { redirect_to @comment.commentable }
				format.js {
					render "shared/refresh.js.erb", locals: {target: @comment.role, content: @comments.deef }
				}
			else
				format.html { redirect_to @comment.commentable, notice: @comment.errors.full_messages.join(", ") }
			end
		end
	end

	def set_default
		authorize! :set_public, @comment
		@comment.public = false
		respond_to do |format|
			if @comment.save
				format.html { redirect_to @comment.commentable }
				format.js {
					render "shared/refresh.js.erb", locals: {target: @comment.role, content: @comments.deef }
				}
			else
				format.html { redirect_to @comment.commentable, notice: @comment.errors.full_messages.join(", ") }
			end
		end
	end

	def paginate 
		role = params[:role]
		@comments = Comment.where(commentable_id: params[:id], role: params[:role])
		parameters = {controller: "comments", action: "paginate", role: role}
	    render "shared/paginate2.js.erb", locals: {target: @comments.role, items: CommentsHelper.pagi( @comments, page: params[:page] ).deef, parameters: parameters }
	end

	private

		def set_collection
			@comments = Comment.where(commentable: @comment.commentable, role: @comment.role)
		end

		def comment_params
			params.require(:comment).permit(:root_id, :root_type, :commentable_id, :commentable_type, :role, :user_id, :title, :comment)
		end
end
