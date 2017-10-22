class OmnitokenMailer < ActionMailer::Base

  def confirmation_email(omnitoken)
    @omnitoken = omnitoken
    mail(to: @omnitoken.email, subject: 'Confirm your email')
  end
end
