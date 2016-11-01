require 'rails_helper'

RSpec.describe Authentication, type: :model do
  describe "#expired?" do
    it "should return true if oauth_expires_at is in the past" do
      authentication = FactoryGirl.create(
        :authentication,
        oauth_expires_at: DateTime.now.utc - 100000
      )

      expect(authentication.expired?).to eq(true)
    end

    it "should return false if oauth_expires_at is in the future" do
      authentication = FactoryGirl.create(:authentication)

      expect(authentication.expired?).to eq(false)
    end
  end
end
