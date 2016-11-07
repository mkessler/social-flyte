require 'rails_helper'

RSpec.describe Campaign, type: :model do
  describe 'associations' do
    it 'belongs to organization' do
      expect(Campaign.reflect_on_association(:organization).macro).to eql(:belongs_to)
    end

    it 'has many posts' do
      expect(Campaign.reflect_on_association(:posts).macro).to eql(:has_many)
    end
  end

  describe 'validations' do
    before(:each) do
      @organization = FactoryGirl.create(:organization)
    end

    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(
        :campaign,
        organization_id: @organization.id
      )
      campaign = Campaign.new(valid_attributes)

      expect(campaign).to be_valid
    end

    it 'is not valid with missing organization' do
      invalid_attributes = FactoryGirl.attributes_for(
        :campaign,
        organization_id: nil
      )
      campaign = Campaign.new(invalid_attributes)

      expect(campaign).to_not be_valid
    end

    it 'is not valid with missing name' do
      invalid_attributes = FactoryGirl.attributes_for(
        :campaign,
        organization_id: @organization.id,
        name: nil
      )
      campaign = Campaign.new(invalid_attributes)

      expect(campaign).to_not be_valid
    end

    it 'is not valid when campaign with same name already exists within organization' do
      organization = FactoryGirl.create(:organization)
      FactoryGirl.create(
        :campaign,
        organization: organization,
        name: 'Summer Sale Contest'
      )
      campaign = Campaign.new(
        organization: organization,
        name: 'Summer Sale Contest'
      )

      expect(campaign).to_not be_valid
    end
  end
end
