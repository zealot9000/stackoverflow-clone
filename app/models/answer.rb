class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true, length: { minimum: 10 }

  accepts_nested_attributes_for :attachments

  scope :first_best, -> { order('best DESC') }

  def mark_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
