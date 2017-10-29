class VotesController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  authorize_resource

  def create
    return render_error unless Vote.types.include?(params[:votable_type])
    @vote = votable.votes.build(vote_params)
    if @vote.save
      render_success(votable, @vote.id, 'create')
    else
      render_error
    end
  end

  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy if current_user.author?(@vote)
    if @vote.destroyed?
      render_success(@vote, :delete)
    else
      render_error
    end
  end

  private

  def render_success(vote, action)
    render json: {
        rating: vote.votable.rating,
        name: vote.votable.class.name.underscore,
        id: vote.votable.id,
        vote_id: vote.id,
        action: action
    }
  end

  def render_error
    render json: { error_text: 'Error to vote.' }, status: :unprocessable_entity
  end

  def votable
    @votable ||= params[:votable_type].constantize.find(params[:votable_id])
  end

  def vote_params
    { user: current_user, rating: params[:up] == 'true' ? 1 : -1 }
  end
end
