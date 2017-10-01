class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes

  def author?(entity)
    id == entity.user_id
  end

  def voted_of?(post)
    ! post.votes.find_by(user_id: self.id).nil?
  end

  def find_vote(post)
    self.votes.find_by(votable_id: post.id)
  end
end
