# require 'rails_helper'
#
# RSpec.describe OrganizationsHelper, type: :helper do
#   let(:organization) { FactoryGirl.create(:organization) }
#   let(:user) { FactoryGirl.create(:user) }
#   let(:membership) { FactoryGirl.create(:membership, organization: organization, user: user) }
#
#   before(:example) do
#     @organization = organization
#     membership
#   end
#
#   describe '#organization_is_active?' do
#     it 'returns true' do
#       expect(organization_is_active?(@organization.id)).to be true
#     end
#
#     it 'returns false' do
#       expect(organization_is_active?(@organization.id + 1)).to be false
#     end
#   end
#
#   describe '#organization_sidenav_active_class' do
#     it 'returns active class' do
#       expect(organization_sidenav_active_class(@organization.id)).to eql('active')
#     end
#
#     it 'returns empty string' do
#       expect(organization_sidenav_active_class(@organization.id + 1)).to eql('')
#     end
#   end
# end
