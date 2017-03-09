require 'rails_helper'

RSpec.describe CampaignsHelper, type: :helper do
  let(:organization) { FactoryGirl.create(:organization) }

  describe 'campaign_networks_icons' do
    it 'returns post network icon elements' do
      campaign = FactoryGirl.create(:campaign, organization: organization)
      twitter_account = FactoryGirl.create(:twitter_account, organization: organization)
      FactoryGirl.create(:post, campaign: campaign)
      FactoryGirl.create(:post, campaign: campaign, network: Network.twitter, twitter_account: twitter_account)
      FactoryGirl.create(:post, campaign: campaign, network: Network.instagram)

      expect(campaign_networks_icons(campaign)).to eql('<i class="fa fa-facebook-official fa-lg"></i><i class="fa fa-instagram-official fa-lg"></i><i class="fa fa-twitter-official fa-lg"></i>')
    end
  end
end
