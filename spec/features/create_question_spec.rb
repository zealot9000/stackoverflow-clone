require_relative 'feature_helper'

feature "Create question", %{
  In order to get answer from community
  As an authenticated user
  I wan to be able to ask questions
}  do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text'
  end

  scenario 'Non-authenticated user ties to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user create invalid question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content "Title can't be blank"
  end

  scenario 'question appears to another user page', js: true do
    title = Faker::Lorem.characters(30)
    body = Faker::Lorem.characters(55)

    Capybara.using_session('user') do
      sign_in(user)
      visit questions_path
    end

    Capybara.using_session('another_user') do
      visit questions_path
    end

    Capybara.using_session('user') do
      click_on 'Ask question'
      fill_in 'Title', with: title
      fill_in 'Body', with: body
      click_on 'Create'
    end

    Capybara.using_session('another_user') do
      expect(page).to have_content title
    end
  end
end
