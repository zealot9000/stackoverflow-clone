require_relative 'feature_helper'

feature 'User sign out' do
  given(:user) { create(:user) }

  scenario 'User sign out' do
    sign_in(user)

    visit root_path
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end