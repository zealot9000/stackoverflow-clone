class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: [:show]

  after_action :publish_question, only: [:create]

  respond_to :html

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
    @answer.attachments.build
  end

  def new
    respond_with(@question = current_user.questions.new)
    @question.attachments.build
  end

  def edit
    # apply load_question
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params) if current_user.author?(@question)
  end

  def destroy
    if current_user.author?(@question)
      respond_with(@question.destroy)
    else
      flash[:alert] = 'No rights to delete'
      render :show
    end
  end

  private

  def build_answer
    gon.question_id = @question.id
    @answer = @question.answers.new
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions', @question)
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
