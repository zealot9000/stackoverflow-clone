require 'rails_helper'

RSpec.describe Search do
  context '.results' do
    let(:query) { 'some query' }

    %w(question answer comment user).each do |attr|
      it 'calls escape request' do
        expect(ThinkingSphinx::Query).to receive(:escape).with(query).and_call_original
        Search.results(query, [attr], '1')
      end
    end

    %w(question answer comment user).each do |attr|
      it 'calls ThinkingSphinx.search' do
        expect(ThinkingSphinx).to receive(:search).with(query, classes: [attr.singularize.classify.constantize], page: '1', per_page: 5).and_call_original
        Search.results(query, [attr], '1')
      end
    end

    it 'return nil with other class' do
      expect(Search.results(query, 'Other', '1')).to be_nil
    end
  end
end
