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
  end
end
