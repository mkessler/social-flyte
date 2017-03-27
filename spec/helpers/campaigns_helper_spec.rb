require 'rails_helper'

RSpec.describe CampaignsHelper, type: :helper do
  let(:organization) { FactoryGirl.create(:organization) }

  describe 'campaign_networks_icons' do
    it 'returns post network icon elements' do
      campaign = FactoryGirl.create(:campaign, organization: organization)
      twitter_token = FactoryGirl.create(:twitter_token, organization: organization)
      FactoryGirl.create(:post, campaign: campaign)
      FactoryGirl.create(:post, campaign: campaign, network: Network.twitter, twitter_token: twitter_token)
      FactoryGirl.create(:post, campaign: campaign, network: Network.instagram)

      expect(campaign_networks_icons(campaign)).to eql('<i class="fa fa-facebook-official fa-lg fa-fw mx-quarter" aria-hidden="true"></i><i class="fa fa-instagram fa-lg fa-fw mx-quarter" aria-hidden="true"></i><i class="fa fa-twitter fa-lg fa-fw mx-quarter" aria-hidden="true"></i>')
    end
  end
end
