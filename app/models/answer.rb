class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 10 }

  scope :first_best, -> { order('best DESC') }

  def mark_best
    ActiveRecord::Base.transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
