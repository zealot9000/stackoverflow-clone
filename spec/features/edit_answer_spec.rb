require_relative 'feature_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of Answer
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end


  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario "Try to edit other user's question", js: true do
      click_on 'Edit question'
      fill_in 'Answer', with: 'edited answer'
      click_on 'Save'

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'edited answer'
      expect(page).to_not have_selector 'textarea'
    end

    scenario "Try to edit other user's question" do

    end
  end
end