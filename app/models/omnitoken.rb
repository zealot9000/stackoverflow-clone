class Omnitoken < ActiveRecord::Base
  belongs_to :user
  belongs_to :authorization

  validates :email, :token, presence: true

  after_create :send_confirmation_token

  def send_confirmation_token
    OmnitokenMailer.confirmation_email(self).deliver_now
  end

  def verify_token(user)
    Omnitoken.transaction do
      if user
        self.authorization.update!(user: user)
        tokenuser = self.user
      else
        self.user.update!(email: token.email)
      end

      self.destroy!
      tokenuser.destroy! if tokenuser
    end
  end
end
