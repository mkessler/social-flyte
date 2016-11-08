require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @organization = FactoryGirl.create(:organization)
    Membership.create(
      user: @user,
      organization: @organization
    )
    @campaign = FactoryGirl.create(
      :campaign,
      organization: @organization
    )
  end

  describe 'GET /posts' do
    it 'works! (now write some real specs)' do
      sign_in(@user)

      get organization_campaign_posts_path(@organization, @campaign)
      expect(response).to have_http_status(200)
    end
  end
end
