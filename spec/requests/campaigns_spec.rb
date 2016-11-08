require 'rails_helper'

RSpec.describe 'Campaigns', type: :request do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @organization = FactoryGirl.create(:organization)
    Membership.create(
      user: @user,
      organization: @organization
    )
  end

  describe 'GET /campaigns' do
    it 'works! (now write some real specs)' do
      sign_in(@user)

      get organization_campaigns_path(@organization)
      expect(response).to have_http_status(200)
    end
  end
end
