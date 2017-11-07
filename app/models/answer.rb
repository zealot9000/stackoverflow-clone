class Answer < ActiveRecord::Base
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true, length: { minimum: 3 }

  after_create :notify_subsribers

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :first_best, -> { order('best DESC') }

  def mark_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end

  private

  def notify_subsribers
    SubscriptionJob.perform_later(self)
  end
end
