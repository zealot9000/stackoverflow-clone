class Omnitoken < ActiveRecord::Base
  belongs_to :user
  belongs_to :authorization

  validates :email, :token, presence: true

  after_create :send_confirmation_token

  def send_confirmation_token
    OmnitokenMailer.confirmation_email(self).deliver_now
  end

  def verify_token(token, user)
    if user
      token.authorization.update!(user: user)
      tokenuser = token.user
    else
      token.user.update!(email: token.email)
    end

    token.destroy!
    tokenuser.destroy! if tokenuser
  end
end
