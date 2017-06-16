require 'rails_helper'

RSpec.describe FacebookToken, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:facebook_token) { FactoryGirl.create(:facebook_token) }

  describe 'associations' do
    it 'belongs to user' do
      expect(FacebookToken.reflect_on_association(:user).macro).to eql(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(
        :facebook_token,
        user_id: user.id
      )
      facebook_token = FacebookToken.new(valid_attributes)

      expect(facebook_token).to be_valid
    end

    it 'is not valid with missing user' do
      invalid_attributes = FactoryGirl.attributes_for(
        :facebook_token,
        user_id: nil
      )
      facebook_token = FacebookToken.new(invalid_attributes)

      expect(facebook_token).to_not be_valid
    end

    it 'is not valid with missing token' do
      invalid_attributes = FactoryGirl.attributes_for(
        :facebook_token,
        user_id: user.id,
        token: nil
      )
      facebook_token = FacebookToken.new(invalid_attributes)

      expect(facebook_token).to_not be_valid
    end
  end

  describe '.expired?' do
    it 'returns true if token has expired' do
      VCR.use_cassette('facebook_get_user_details') do
        facebook_token.expires_at = Time.now - 1.day
        expect(facebook_token.expired?).to be true
      end
    end

    it 'returns false if token has not expired' do
      VCR.use_cassette('facebook_get_user_details') do
        expect(facebook_token.expired?).to be false
      end
    end
  end
end
