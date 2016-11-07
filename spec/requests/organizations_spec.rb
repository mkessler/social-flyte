require 'rails_helper'

RSpec.describe 'Organizations', type: :request do
  describe 'GET /organizations/new' do
    it 'works! (now write some real specs)' do
      user = FactoryGirl.create(:user)
      sign_in(user)

      get new_organization_path
      expect(response).to have_http_status(200)
    end
  end
end
