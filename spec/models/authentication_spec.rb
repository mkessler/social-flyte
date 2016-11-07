require 'rails_helper'

RSpec.describe Authentication, type: :model do
  describe 'validations' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(
        :authentication,
        user_id: @user.id
      )
      authentication = Authentication.new(valid_attributes)

      expect(authentication).to be_valid
    end

    it 'is not valid with missing user' do
      invalid_attributes = FactoryGirl.attributes_for(
        :authentication,
        user_id: nil
      )
      authentication = Authentication.new(invalid_attributes)

      expect(authentication).to_not be_valid
    end

    it 'is not valid with missing network' do
      invalid_attributes = FactoryGirl.attributes_for(
        :authentication,
        user_id: @user_id,
        network: nil
      )
      authentication = Authentication.new(invalid_attributes)

      expect(authentication).to_not be_valid
    end

    it 'is not valid with missing network_user_id' do
      invalid_attributes = FactoryGirl.attributes_for(
        :authentication,
        user_id: @user_id,
        network_user_id: nil
      )
      authentication = Authentication.new(invalid_attributes)

      expect(authentication).to_not be_valid
    end

    it 'is not valid with missing token' do
      invalid_attributes = FactoryGirl.attributes_for(
        :authentication,
        user_id: @user_id,
        token: nil
      )
      authentication = Authentication.new(invalid_attributes)

      expect(authentication).to_not be_valid
    end

    it 'is not valid with missing expires_at' do
      invalid_attributes = FactoryGirl.attributes_for(
        :authentication,
        user_id: @user_id,
        expires_at: nil
      )
      authentication = Authentication.new(invalid_attributes)

      expect(authentication).to_not be_valid
    end
  end

  describe '.expired?' do
    it 'should return true if expires_at is in the past' do
      authentication = FactoryGirl.create(
        :authentication,
        expires_at: DateTime.now.utc - 100000
      )

      expect(authentication.expired?).to eq(true)
    end

    it 'should return false if expires_at is in the future' do
      authentication = FactoryGirl.create(:authentication)

      expect(authentication.expired?).to eq(false)
    end
  end
end
