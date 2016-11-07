require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /posts' do
    it 'works! (now write some real specs)' do
      user = FactoryGirl.create(:user)
      sign_in(user)

      get posts_path
      expect(response).to have_http_status(200)
    end
  end
end
