class AddUserIdToAnswers < ActiveRecord::Migration
  def change
    add_reference :answers, :user, foreign_key: true
  end
end
