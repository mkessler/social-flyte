require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'associations' do
    it 'has many memberships' do
      expect(Organization.reflect_on_association(:memberships).macro).to eql(:has_many)
    end

    it 'has many users' do
      expect(Organization.reflect_on_association(:users).macro).to eql(:has_many)
    end

    it 'has many campaigns' do
      expect(Organization.reflect_on_association(:campaigns).macro).to eql(:has_many)
    end

    it 'has many twitter tokens' do
      expect(Organization.reflect_on_association(:twitter_tokens).macro).to eql(:has_many)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(:organization)
      organization = Organization.new(valid_attributes)

      expect(organization).to be_valid
    end

    it 'is not valid with missing name' do
      invalid_attributes = {name: nil}
      organization = Organization.new(invalid_attributes)

      expect(organization).to_not be_valid
    end
  end

  describe '.regenerate_slug' do
    it 'triggers friendly_id to regenerate the slug to include the id if multiple records with same name exist' do
      organization = Organization.create(name: 'Groala')
      organization_two = Organization.create(name: 'Groala')
      organization_three = Organization.create(name: 'Groala')

      expect(organization.slug).to eql('groala')
      expect(organization_two.slug).to eql("groala-#{organization_two.id}")
      expect(organization_three.slug).to eql("groala-#{organization_three.id}")
    end
  end
end
