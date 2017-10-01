module VotesHelper
  def delete_vote_class(entity)
    "#{entity.class.name.underscore}-del-#{entity.id} #{'hidden' unless current_user.voted_of?(entity)}"
  end

  def up_down_vote_class(entity)
    "#{entity.class.name.underscore}-up-down-#{entity.id} #{'hidden' if current_user.voted_of?(entity)}"
  end

  def delete_vote_path(entity)
    current_user.voted_of?(entity) ? vote_path(current_user.find_vote(entity)) : '#'
  end
end
