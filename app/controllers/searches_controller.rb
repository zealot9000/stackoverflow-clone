class SearchesController < ApplicationController

  authorize_resource

  def show
    params[:scopes] = Search::TYPES if params[:scopes].blank?
    if params[:text]
      @results = Search.results(params[:text], params[:scopes], params[:page])
      respond_with(@results)
    end
  end
end
