require 'rails_helper'

RSpec.describe CampaignsHelper, type: :helper do
  describe 'campaign_networks_icons' do
    it 'returns post network icon elements' do
      campaign = FactoryGirl.create(:campaign)
      FactoryGirl.create(:post, campaign: campaign)
      FactoryGirl.create(:post, campaign: campaign, network: Network.twitter)
      FactoryGirl.create(:post, campaign: campaign, network: Network.instagram)

      expect(campaign_networks_icons(campaign)).to eql('<i class="fa fa-facebook-official"></i><i class="fa fa-twitter-official"></i><i class="fa fa-instagram-official"></i>')
    end
  end
end
