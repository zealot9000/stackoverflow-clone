class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :user

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments
end
