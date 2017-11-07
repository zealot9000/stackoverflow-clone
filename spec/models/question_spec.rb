require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  describe 'association' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:attachments) }
    it { should accept_nested_attributes_for :attachments }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'digest scope' do
    let(:questions) { create_list(:question, 2) }
    let(:questions_old) { create_list(:question, 2, created_at: Date.current.at_beginning_of_day - 1) }

    it 'returns today questions' do
      expect(Question.digest).to eq questions
    end

    it 'not returns old questions' do
      expect(Question.digest).not_to eq questions_old
    end
  end

  describe 'subscribe' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'create subscription to author after create question' do
      expect(question.subscriptions).to include(Subscription.find_by(user: user, question: question))
    end
  end
end
