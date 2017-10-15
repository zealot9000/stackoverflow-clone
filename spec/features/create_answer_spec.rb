require_relative 'feature_helper'

feature 'Create answer', %q{
  In order to offer an answer
  As a user
  I want to be able to write the answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user create answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'My answer text'
    click_on 'Add new answer'

    within '.answers' do
      expect(page).to have_content 'My answer text'
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user create answer with invalid attributes', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Add new answer'
#    save_and_open_page
#    sleep(5)
    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non-authenticated user try to creates question', js: true do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'answer appears to another user page', js: true do
    body = Faker::Lorem.characters(55)

    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('another_user') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      fill_in 'Body', with: body
      click_on 'Create answer'
    end

    Capybara.using_session('another_user') do
      within '.answers' do
        expect(page).to have_content body
      end
    end
  end
end
