require 'rails_helper'

RSpec.describe OrganizationsHelper, type: :helper do
  let(:organization) { FactoryGirl.create(:organization) }
  let(:user) { FactoryGirl.create(:user) }
  let(:memberhip) { FactoryGirl.create(:membership, organization: organization, user: user) }

  before(:example) do
    memberhip
  end

  describe 'organization_title' do
    context 'has no campaigns' do
      it 'returns welcome title' do
        expect(organization_title(organization)).to eql('Welcome to groala')
      end
    end

    context 'has campaigns' do
      it 'returns organization name' do
        FactoryGirl.create(:campaign, organization: organization)
        expect(organization_title(organization)).to eql(organization.name)
      end
    end
  end
end
