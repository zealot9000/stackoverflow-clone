class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:destroy, :update, :mark_best]

  after_action :publish_answer, only: [:create]

  respond_to :js

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params))
  end

  def destroy
    @answer.destroy
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def mark_best
    @answer.mark_best
  end

  private

  def publish_answer
    return if @answer.errors.any?
    attachments = []
    @answer.attachments.each { |a| attachments << {id: a.id, identifier: a.file.identifier, url: a.file.url} }
    ActionCable.server.broadcast(
      "question_#{@question.id}_answers",
      answer: @answer,
      attachments: @attachments,
      author_question: @question.user.id
    )
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy]).merge(user_id: current_user.id)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
