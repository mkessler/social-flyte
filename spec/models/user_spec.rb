require 'rails_helper'

RSpec.describe User, type: :model do
  let (:user) { FactoryGirl.create(:user) }

  describe 'associations' do
    # it 'has many memberships' do
    #   expect(User.reflect_on_association(:memberships).macro).to eql(:has_many)
    # end
    #
    # it 'has many organizations' do
    #   expect(User.reflect_on_association(:organizations).macro).to eql(:has_many)
    # end

    it 'has many posts' do
      expect(User.reflect_on_association(:posts).macro).to eql(:has_many)
    end

    it 'has one facebook token' do
      expect(User.reflect_on_association(:facebook_token).macro).to eql(:has_one)
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

  describe '.has_valid_facebook_token?' do
    context 'facebook' do
      it 'returns true' do
        VCR.use_cassette('facebook_get_user_details') do
          FactoryGirl.create(:facebook_token, user_id: user.id)
        end
        expect(user.has_valid_facebook_token?).to be true
      end

      it 'returns false' do
        expect(user.has_valid_facebook_token?).to be false
      end
    end
  end
end
