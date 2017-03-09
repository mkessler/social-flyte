require 'rails_helper'

RSpec.describe TwitterAccount, type: :model do
  let(:organization) { FactoryGirl.create(:organization) }
  let(:twitter_account) { FactoryGirl.create(:twitter_account) }

  describe 'associations' do
    it 'belongs to organization' do
      expect(TwitterAccount.reflect_on_association(:organization).macro).to eql(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(
        :twitter_account,
        organization_id: organization.id
      )
      twitter_account = TwitterAccount.new(valid_attributes)

      expect(twitter_account).to be_valid
    end

    it 'is not valid with missing organization' do
      invalid_attributes = FactoryGirl.attributes_for(
        :twitter_account,
        organization_id: nil
      )
      twitter_account = TwitterAccount.new(invalid_attributes)

      expect(twitter_account).to_not be_valid
    end

    it 'is not valid with missing token' do
      invalid_attributes = FactoryGirl.attributes_for(
        :twitter_account,
        organization_id: organization.id,
        token: nil
      )
      twitter_account = TwitterAccount.new(invalid_attributes)

      expect(twitter_account).to_not be_valid
    end

    it 'is not valid with missing secret' do
      invalid_attributes = FactoryGirl.attributes_for(
        :twitter_account,
        organization_id: organization.id,
        secret: nil
      )
      twitter_account = TwitterAccount.new(invalid_attributes)

      expect(twitter_account).to_not be_valid
    end

    it 'is not valid with missing screen name' do
      invalid_attributes = FactoryGirl.attributes_for(
        :twitter_account,
        organization_id: organization.id,
        screen_name: nil
      )
      twitter_account = TwitterAccount.new(invalid_attributes)

      expect(twitter_account).to_not be_valid
    end

    it 'is not valid with missing image url' do
      invalid_attributes = FactoryGirl.attributes_for(
        :twitter_account,
        organization_id: organization.id,
        image_url: nil
      )
      twitter_account = TwitterAccount.new(invalid_attributes)

      expect(twitter_account).to_not be_valid
    end

    it 'is not valid if twitter account already exists within organization' do
      FactoryGirl.create(
        :twitter_account,
        organization_id: organization.id,
        twitter_id: '1234'
      )
      invalid_attributes = FactoryGirl.attributes_for(
        :twitter_account,
        organization_id: organization.id,
        twitter_id: '1234'
      )
      twitter_account = TwitterAccount.new(invalid_attributes)

      expect(twitter_account).to_not be_valid
    end
  end

  describe '.screen_name' do
    it 'prepends @ to screen name' do
      expect(twitter_account.screen_name.first).to eql('@')
    end
  end
end
