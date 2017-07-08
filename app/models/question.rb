class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :user

  validates :title, :body, presence: true
end
