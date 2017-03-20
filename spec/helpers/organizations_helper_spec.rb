require 'rails_helper'

RSpec.describe OrganizationsHelper, type: :helper do
  describe 'organization_title' do
    context 'has no campaigns' do
      it 'returns welcome title' do
        organization = FactoryGirl.create(:organization)

        expect(organization_title(organization)).to eql('Welcome to groala')
      end
    end

    context 'has campaigns' do
      it 'returns organization name' do
        organization = FactoryGirl.create(:organization)
        FactoryGirl.create(:campaign, organization: organization)

        expect(organization_title(organization)).to eql(organization.name)
      end
    end
  end

  describe 'organization_title_class' do
    context 'member of more than 1 organization' do
      it 'returns extended class name' do
        user =  FactoryGirl.create(:user)
        organization = FactoryGirl.create(:organization)
        organization_two = FactoryGirl.create(:organization)
        FactoryGirl.create(:membership, organization: organization, user: user)
        FactoryGirl.create(:membership, organization: organization_two, user: user)

        expect(organization_title_class(user)).to eql('dashboard-title extended-title-nav')
      end
    end

    context 'not member of more than 1 organization' do
      it 'returns standard class name' do
        user =  FactoryGirl.create(:user)
        organization = FactoryGirl.create(:organization)
        FactoryGirl.create(:membership, organization: organization, user: user)

        expect(organization_title_class(user)).to eql('dashboard-title')
      end
    end
  end
end
