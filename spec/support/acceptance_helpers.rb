module AcceptanceHelper
  Capybara.server = :puma

  def sign_in(user)
    visit new_user_session_path # или '/sign_in'
    fill_in 'Email', with: user.email # 'user@test.com'
    fill_in 'Password', with: user.password # '12345678'
    click_on 'Log in'
  end
end