require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the CampaignsHelper. For example:
#
# describe CampaignsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
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
