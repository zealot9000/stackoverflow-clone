class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question_#{params[:commentable_id]}_comments"
  end
end
