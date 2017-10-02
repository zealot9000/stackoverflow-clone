class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    if Vote.types.include?(params[:votable_type])
      @vote = Vote.new(vote_params)
      if @vote.save
        render_success(@vote, :create)
      else
        render_error
      end
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
    params[:votable_type].constantize.find(params[:votable_id])
  end

  def vote_params
    # votable = params[:votable_type].constantize.find(params[:votable_id])
    { user: current_user, rating: params[:up] == 'true' ? 1 : -1, votable: votable }
  end
end
