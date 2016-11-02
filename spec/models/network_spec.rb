require 'rails_helper'

RSpec.describe Network, type: :model do
  describe "#facebook" do
    it "should return record for facebook" do
      facebook = Network.find_by_slug('facebook')
      expect(Network.facebook).to eql(facebook)
    end
  end

  describe "#twitter" do
    it "should return record for twitter" do
      twitter = Network.find_by_slug('twitter')
      expect(Network.twitter).to eql(twitter)
    end
  end

  describe "#instagram" do
    it "should return record for instagram" do
      instagram = Network.find_by_slug('instagram')
      expect(Network.instagram).to eql(instagram)
    end
  end
end
