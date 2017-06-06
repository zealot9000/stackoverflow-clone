class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question, only: [:create]

  def show
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to @answer.question
    else
      flash[:alert] = 'No rights to delete'
      @question = @answer.question
      render 'questions/show'
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
