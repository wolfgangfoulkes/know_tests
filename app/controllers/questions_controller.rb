class QuestionsController < ApplicationController
  load_and_authorize_resource :question

  def create
  	respond_to do |format|
		if @question.save
			format.html { redirect_to @question }
		else
			format.html { redirect_to @question, notice: @question.errors.full_messages.join(", ") }
		end
	end
  end

  def show
  end

  def destroy
  end

  private
  	def question_params
  		params.require(:question).permit(:subject, :content)
  	end
end
