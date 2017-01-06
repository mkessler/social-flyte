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
end
