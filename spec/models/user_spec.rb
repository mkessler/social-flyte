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

  describe '.process_invitation' do
    context 'has valid invitation' do
      it 'returns true' do
        invitation = FactoryGirl.create(:invitation, email: user.email)
        user.process_invitation(invitation.token)
        invitation.reload

        expect(invitation.accepted).to eql(true)
        expect(invitation.recipient_id).to eql(user.id)
      end
    end

    context 'does not have valid invitation' do
      it 'returns false' do
        invitation = FactoryGirl.create(:invitation)
        user.process_invitation(invitation.token)
        invitation.reload

        expect(invitation.accepted).to eql(false)
        expect(invitation.recipient_id).to be_nil
      end
    end
  end
end
