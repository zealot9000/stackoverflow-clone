require_relative 'feature_helper'

feature 'Guest sign up', %q{
  To ask a question
  As a guest
  I have to register
} do

  scenario 'Registration new user with valid parameters' do
    visit new_user_registration_path
    fill_in 'Email', with: 'usertest@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Registration new user with invalid parameters' do
    visit new_user_registration_path
    fill_in 'Email', with: 'usertest@test.com'
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''
    click_on 'Sign up'

    expect(page).to have_content "Password can't be blank"
  end
end