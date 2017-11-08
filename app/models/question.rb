class Question < ActiveRecord::Base
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :subsribe

  scope :digest, ->{ where(created_at: Date.current.at_beginning_of_day..Date.current.at_end_of_day) }

  private

  def subsribe
    self.subscriptions.create(user: self.user)
  end
end
