require 'rails_helper'

RSpec.describe "FacebookTokens", type: :request do
  describe "GET /facebook_tokens" do
    it "works! (now write some real specs)" do
      get facebook_tokens_path
      expect(response).to have_http_status(200)
    end
  end
end
