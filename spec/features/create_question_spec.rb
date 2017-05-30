require 'rails_helper'

feature "Create question", %{
In order to get answer from community
As an authenticated user
I wan to be able to ask questions
}  do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates quistion' do
    # User.create!(email: 'user@test.com', password: '12345678')
    # выносим в модуль
    sign_in(user)
    # visit new_user_session_path # или '/sign_in'
    # fill_in 'Email', with: user.email # 'user@test.com'
    # fill_in 'Password', with: user.password # '12345678'
    # click_on 'Log in'

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Non-authenticated user ties to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
