class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true, touch: true
  belongs_to :user

  TYPES = %w(Answer Question)

  validates :votable_id, :votable_type, :rating, presence: true
  validates :votable_type, inclusion: { :in => TYPES }
  validates :rating, inclusion: { :in => [1, -1] }
  validate :author_validation

  def self.types
    TYPES
  end

  private

  def author_validation
    errors.add(:user, "User is an author of object.") if user.author?(self.votable)
  end
end
