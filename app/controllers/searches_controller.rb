class SearchesController < ApplicationController

  authorize_resource

  def show
    if params[:text] && params[:scopes]
      @results = Search.results(params[:text], params[:scopes], params[:page])
      respond_with(@results)
    elsif params[:text]
      params[:scopes] = Search::TYPES
      @results = Search.results(params[:text], params[:scopes], params[:page])
      respond_with(@results)
    end
  end
end
