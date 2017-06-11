require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an User
  I want to be able so sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    # выносим в given
    # User.create!(email: 'user@test.com', password: '12345678')
    # выносим в модуль
    sign_in(user)
    # visit new_user_session_path # или '/sign_in'
    # fill_in 'Email', with: user.email #'user@test.com'
    # fill_in 'Password', with: user.password #'12345678'
    # click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path # или '/sign_in'
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password'
    expect(current_path).to eq new_user_session_path
  end
end