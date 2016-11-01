require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#facebook_auth" do
    it "should return the user's Facebook Authentication record if exists" do
      user = FactoryGirl.create(:user)
      authentication = FactoryGirl.create(
        :authentication,
        user: user,
        provider: NETWORK_PROVIDERS[:facebook]
      )

      expect(user.facebook_auth).to eq(authentication)
    end

    it "should return nil if the user's Facebook Authentication record does not exist" do
      user = FactoryGirl.create(:user)

      expect(user.facebook_auth).to be_nil
    end
  end
end
