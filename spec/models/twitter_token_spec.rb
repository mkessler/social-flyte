require 'rails_helper'

RSpec.describe TwitterToken, type: :model do
  let(:organization) { FactoryGirl.create(:organization) }
  let(:twitter_token) { FactoryGirl.create(:twitter_token) }

  describe 'associations' do
    it 'belongs to organization' do
      expect(TwitterToken.reflect_on_association(:organization).macro).to eql(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(
        :twitter_token,
        organization_id: organization.id
      )
      twitter_token = TwitterToken.new(valid_attributes)

      expect(twitter_token).to be_valid
    end

    it 'is not valid with missing organization' do
      invalid_attributes = FactoryGirl.attributes_for(
        :twitter_token,
        organization_id: nil
      )
      twitter_token = TwitterToken.new(invalid_attributes)

      expect(twitter_token).to_not be_valid
    end

    it 'is not valid with missing token' do
      invalid_attributes = FactoryGirl.attributes_for(
        :twitter_token,
        organization_id: organization.id,
        token: nil
      )
      twitter_token = TwitterToken.new(invalid_attributes)

      expect(twitter_token).to_not be_valid
    end

    it 'is not valid with missing secret' do
      invalid_attributes = FactoryGirl.attributes_for(
        :twitter_token,
        organization_id: organization.id,
        secret: nil
      )
      twitter_token = TwitterToken.new(invalid_attributes)

      expect(twitter_token).to_not be_valid
    end

    it 'is not valid with missing user name' do
      invalid_attributes = FactoryGirl.attributes_for(
        :twitter_token,
        organization_id: organization.id,
        network_user_name: nil
      )
      twitter_token = TwitterToken.new(invalid_attributes)

      expect(twitter_token).to_not be_valid
    end

    it 'is not valid if twitter account already exists within organization' do
      FactoryGirl.create(
        :twitter_token,
        organization_id: organization.id,
        network_user_id: '1234'
      )
      invalid_attributes = FactoryGirl.attributes_for(
        :twitter_token,
        organization_id: organization.id,
        network_user_id: '1234'
      )
      twitter_token = TwitterToken.new(invalid_attributes)

      expect(twitter_token).to_not be_valid
    end
  end

  describe '.network_user_name' do
    it 'prepends @ to user name' do
      expect(twitter_token.network_user_name.first).to eql('@')
    end
  end
end
