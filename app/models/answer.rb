class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :attachments

  validates :body, presence: true, length: { minimum: 10 }

  scope :first_best, -> { order('best DESC') }

  def mark_best
    ActiveRecord::Base.transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
