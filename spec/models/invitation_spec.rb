require 'rails_helper'

RSpec.describe Invitation, type: :model do
  let(:organization) { FactoryGirl.create(:organization) }

  describe 'associations' do
    it 'belongs to organization' do
      expect(Invitation.reflect_on_association(:organization).macro).to eql(:belongs_to)
    end

    it 'belongs to sender (user)' do
      expect(Invitation.reflect_on_association(:sender).macro).to eql(:belongs_to)
    end

    it 'belongs to recipient (user)' do
      expect(Invitation.reflect_on_association(:recipient).macro).to eql(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(
        :invitation,
        organization_id: organization.id
      )
      invitation = Invitation.new(valid_attributes)

      expect(invitation).to be_valid
    end

    it 'is not valid with missing organization' do
      invalid_attributes = FactoryGirl.attributes_for(
        :invitation,
        organization_id: nil
      )
      invitation = Invitation.new(invalid_attributes)

      expect(invitation).to_not be_valid
    end

    it 'is not valid with missing sender (user)' do
      invalid_attributes = FactoryGirl.attributes_for(
        :invitation,
        organization_id: organization.id,
        sender_id: nil
      )
      invitation = Invitation.new(invalid_attributes)

      expect(invitation).to_not be_valid
    end

    it 'is not valid with missing email' do
      invalid_attributes = FactoryGirl.attributes_for(
        :invitation,
        organization_id: organization.id,
        email: nil
      )
      invitation = Invitation.new(invalid_attributes)

      expect(invitation).to_not be_valid
    end

    it 'is not valid with invalid email' do
      invalid_attributes = FactoryGirl.attributes_for(
        :invitation,
        organization_id: organization.id,
        email: 'hey123'
      )
      invitation = Invitation.new(invalid_attributes)

      expect(invitation).to_not be_valid
    end

    it 'is not valid when invitation for email and organization already exists' do
      FactoryGirl.create(
        :invitation,
        organization: organization,
        email: 'test@example.com'
      )
      invitation = Invitation.new(
        organization: organization,
        email: 'test@example.com'
      )

      expect(invitation).to_not be_valid
    end
  end

  describe 'scope' do
    before(:context) do
      2.times { FactoryGirl.create(:invitation, accepted: true) }
      4.times { FactoryGirl.create(:invitation) }
    end

    describe 'pending' do
      it 'should return only invitations that have not been accepted' do
        expect(Invitation.pending).to eq(Invitation.where(accepted: false))
        expect(Invitation.pending.count).to eql(4)
      end
    end
  end

  describe '.generate_token' do
    it 'generates an authentication token when an invitation is created' do
      invitation = FactoryGirl.create(:invitation)

      expect(invitation.token).to be_truthy
    end
  end

  describe '.create_membership' do
    it 'creates membership for invitation recipient and organization' do
      user = FactoryGirl.create(:user)
      invitation = FactoryGirl.create(
        :invitation,
        organization: organization,
        email: user.email
      )

      expect(user.organizations).to_not include(organization)

      invitation.update_attribute(:accepted, true)
      expect(user.reload.organizations).to include(organization)
    end
  end

  describe '.set_recipient_id' do
    it 'sets recipient_id if user exists when invitation is created' do
      user = FactoryGirl.create(:user)
      invitation = FactoryGirl.create(:invitation, email: user.email)

      expect(invitation.recipient_id).to eql(user.id)
    end
  end
end
