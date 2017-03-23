require 'rails_helper'

RSpec.describe "TwitterTokens", type: :request do
  describe "GET /twitter_tokens" do
    it "works! (now write some real specs)" do
      get twitter_tokens_path
      expect(response).to have_http_status(200)
    end
  end
end
