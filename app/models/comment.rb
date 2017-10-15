class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  TYPES = %w(Answer Question)

  validates :body, presence: true, length: {minimum: 3}
  validates :commentable_id, :commentable_type, presence: true
  validates :commentable_type, inclusion: { :in => TYPES }

  def self.types
    TYPES
  end
end
