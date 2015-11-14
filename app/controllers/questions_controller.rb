class QuestionsController < ApplicationController
  load_and_authorize_resource :event, :only => [:create, :destroy]
  load_and_authorize_resource :question, :through => :event, :only => [:create, :destroy]
  load_and_authorize_resource :question, :only => :show

  def create
  	respond_to do |format|
  		if @question.save
  			format.html { redirect_to @event }
  		else
  			format.html { redirect_to @event, notice: @question.errors.full_messages.join(", ") }
  		end
  	end
  end

  def show
  end

  def destroy
    @question.destroy
    respond_to do |format|
      format.js   { render 'shared/refresh_list.js.erb', locals: {target: "questions", collection: @event.questions.deef} }
    end
  end

  private
  	def question_params
  		params.require(:question).permit(:subject, :content)
  	end
end
