# require 'rails_helper'
#
# RSpec.describe Membership, type: :model do
#   let(:user) { FactoryGirl.create(:user) }
#   let(:organization) { FactoryGirl.create(:organization) }
#
#   describe 'associations' do
#     it 'belongs to user' do
#       expect(Membership.reflect_on_association(:user).macro).to eql(:belongs_to)
#     end
#
#     it 'belongs to organization' do
#       expect(Membership.reflect_on_association(:organization).macro).to eql(:belongs_to)
#     end
#   end
#
#   describe 'validations' do
#     it 'is valid with valid attributes' do
#       valid_attributes = FactoryGirl.attributes_for(
#         :membership,
#         user_id: user.id,
#         organization_id: organization.id
#       )
#       membership = Membership.new(valid_attributes)
#
#       expect(membership).to be_valid
#     end
#
#     it 'is not valid with missing user' do
#       invalid_attributes = FactoryGirl.attributes_for(
#         :membership,
#         user_id: nil,
#         organization_id: organization.id
#       )
#       membership = Membership.new(invalid_attributes)
#
#       expect(membership).to_not be_valid
#     end
#
#     it 'is not valid with missing organization' do
#       invalid_attributes = FactoryGirl.attributes_for(
#         :membership,
#         user_id: user.id,
#         organization_id: nil
#       )
#       membership = Membership.new(invalid_attributes)
#
#       expect(membership).to_not be_valid
#     end
#
#     it 'is not valid if membership already exists for organization and user' do
#       FactoryGirl.create(
#         :membership,
#         user_id: user.id,
#         organization_id: organization.id
#       )
#       valid_attributes = FactoryGirl.attributes_for(
#         :membership,
#         user_id: user.id,
#         organization_id: organization.id
#       )
#       membership = Membership.new(valid_attributes)
#
#       expect(membership).to_not be_valid
#     end
#   end
# end
