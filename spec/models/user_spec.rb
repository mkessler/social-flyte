require 'rails_helper'

RSpec.describe User, type: :model do
  let (:user) { FactoryGirl.create(:user) }

  describe 'associations' do
    it 'has many memberships' do
      expect(User.reflect_on_association(:memberships).macro).to eql(:has_many)
    end

    it 'has many organizations' do
      expect(User.reflect_on_association(:organizations).macro).to eql(:has_many)
    end

    it 'has many authentications' do
      expect(User.reflect_on_association(:authentications).macro).to eql(:has_many)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(:user)
      user = User.new(valid_attributes)

      expect(user).to be_valid
    end

    it 'is not valid with missing first_name' do
      invalid_attributes = FactoryGirl.attributes_for(
        :user,
        first_name: nil
      )
      user = User.new(invalid_attributes)

      expect(user).to_not be_valid
    end

    it 'is not valid with missing last_name' do
      invalid_attributes = FactoryGirl.attributes_for(
        :user,
        last_name: nil
      )
      user = User.new(invalid_attributes)

      expect(user).to_not be_valid
    end

    it 'is not valid with missing email' do
      invalid_attributes = FactoryGirl.attributes_for(
        :user,
        email: nil
      )
      user = User.new(invalid_attributes)

      expect(user).to_not be_valid
    end

    it 'is not valid with missing password' do
      invalid_attributes = FactoryGirl.attributes_for(
        :user,
        password: nil
      )
      user = User.new(invalid_attributes)

      expect(user).to_not be_valid
    end
  end

  describe '.facebook_authentication' do
    it "should return the user's Facebook Authentication record if exists" do
      authentication = FactoryGirl.create(
        :authentication,
        user: user,
        network: Network.facebook
      )

      expect(user.facebook_authentication).to eq(authentication)
    end

    it "should return nil if the user's Facebook Authentication record does not exist" do
      expect(user.facebook_authentication).to be_nil
    end
  end

  describe '.has_valid_network_token?' do
    context 'facebook' do
      context 'does not have valid token' do
        it 'returns false if token doesn\'t exist' do
          expect(user.has_valid_network_token?(Network.facebook)).to eql(false)
        end

        it 'returns false if token is expired' do
          authentication = FactoryGirl.create(
            :authentication,
            user: user,
            network: Network.facebook,
            expires_at: 1.day.ago
          )
          expect(user.has_valid_network_token?(Network.facebook)).to eql(false)
        end
      end

      context 'does have valid token' do
        it 'returns true' do
          authentication = FactoryGirl.create(
            :authentication,
            user: user,
            network: Network.facebook
          )
          expect(user.has_valid_network_token?(Network.facebook)).to eql(true)
        end
      end
    end
  end
end
