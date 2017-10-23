class OmnitokensController < ApplicationController

  def register_email
    @user = User.find_by(id: session[:user_id])
    @auth = Authorization.find_by(uid: session[:auth_uid], provider: session[:auth_provider])
    Omnitoken.create!(user: @user, authorization: @auth, email: session[:email], token: Devise.friendly_token)
  end

  def verify_email
    token = Omnitoken.find_by(token: params[:token])
    user = User.find_by(email: token.email)

    verify_token(token, user)

    flash[:notice] = 'Your account updated.'
    redirect_to root_path
  end
end
