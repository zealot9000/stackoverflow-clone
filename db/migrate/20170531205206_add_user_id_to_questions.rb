class AddUserIdToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :user, foreign_key: true
  end
end
