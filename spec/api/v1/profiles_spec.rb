require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it_behaves_like 'API Successable'

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not content encrypted #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: {format: :json}.merge(options)
    end
  end

  describe 'GET /profiles' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:other_users) { create_list(:user, 2) }

      before { get '/api/v1/profiles', params: {format: :json, access_token: access_token.token} }

      it_behaves_like 'API Successable'

      it 'contains users' do
        expect(response.body).to be_json_eql(other_users.to_json)
      end

      it 'does no contain me' do
        JSON.parse(response.body).each do |item|
          expect(item[:id]).to_not eq me.id
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles', params: {format: :json}.merge(options)
    end
  end
end