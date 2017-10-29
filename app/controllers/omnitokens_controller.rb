class OmnitokensController < ApplicationController

  skip_authorization_check

  def register_email
    @user = User.find_by(id: session['devise.user_id'])
    @auth = Authorization.find_by(uid: session['device.auth_uid'], provider: session['devise.auth_provider'])
    Omnitoken.create!(user: @user, authorization: @auth, email: params[:email], token: Devise.friendly_token)
  end

  def verify_email
    token = Omnitoken.find_by(token: params[:token])
    user = User.find_by(email: token.email)

    token.verify_token(user)

    flash[:notice] = 'Your account updated.'
    redirect_to root_path
  end
end
