# require 'rails_helper'
#
# RSpec.describe Campaign, type: :model do
#   let(:organization) { FactoryGirl.create(:organization) }
#
#   describe 'associations' do
#     it 'belongs to organization' do
#       expect(Campaign.reflect_on_association(:organization).macro).to eql(:belongs_to)
#     end
#
#     it 'has many posts' do
#       expect(Campaign.reflect_on_association(:posts).macro).to eql(:has_many)
#     end
#   end
#
#   describe 'validations' do
#     it 'is valid with valid attributes' do
#       valid_attributes = FactoryGirl.attributes_for(
#         :campaign,
#         organization_id: organization.id
#       )
#       campaign = Campaign.new(valid_attributes)
#
#       expect(campaign).to be_valid
#     end
#
#     it 'is not valid with missing organization' do
#       invalid_attributes = FactoryGirl.attributes_for(
#         :campaign,
#         organization_id: nil
#       )
#       campaign = Campaign.new(invalid_attributes)
#
#       expect(campaign).to_not be_valid
#     end
#
#     it 'is not valid with missing name' do
#       invalid_attributes = FactoryGirl.attributes_for(
#         :campaign,
#         organization_id: organization.id,
#         name: nil
#       )
#       campaign = Campaign.new(invalid_attributes)
#
#       expect(campaign).to_not be_valid
#     end
#
#     it 'is not valid when campaign with same name already exists within organization' do
#       organization = FactoryGirl.create(:organization)
#       FactoryGirl.create(
#         :campaign,
#         organization: organization,
#         name: 'Summer Sale Contest'
#       )
#       campaign = Campaign.new(
#         organization: organization,
#         name: 'Summer Sale Contest'
#       )
#
#       expect(campaign).to_not be_valid
#     end
#
#     it 'is not valid when campaign with same slug already exists within organization' do
#       organization = FactoryGirl.create(:organization)
#       FactoryGirl.create(
#         :campaign,
#         organization: organization,
#         slug: 'summer-sale-contest'
#       )
#       campaign = Campaign.new(
#         organization: organization,
#         slug: 'summer-sale-contest'
#       )
#
#       expect(campaign).to_not be_valid
#     end
#   end
#
#   describe '.engagement_count' do
#     it 'returns the total number of post interactions' do
#       campaign = FactoryGirl.create(:campaign)
#       post = FactoryGirl.create(:post, campaign: campaign)
#       post_two = FactoryGirl.create(:post, campaign: campaign, network_post_id: Faker::Number.number(10))
#
#       10.times do
#         FactoryGirl.create(:comment, network_comment_id: Faker::Number.number(10), post: post)
#       end
#       4.times do
#         FactoryGirl.create(:reaction, network_user_id: Faker::Number.number(10),post: post)
#       end
#
#       5.times do
#         FactoryGirl.create(:comment, network_comment_id: Faker::Number.number(10), post: post)
#       end
#       8.times do
#         FactoryGirl.create(:reaction, network_user_id: Faker::Number.number(10),post: post)
#       end
#
#       expect(campaign.engagement_count).to eql(27)
#     end
#   end
#
#   describe '.networks' do
#     it 'returns an array of post networks' do
#       campaign = FactoryGirl.create(:campaign, organization: organization)
#       FactoryGirl.create(:post, campaign: campaign)
#
#       expect(campaign.networks).to eql(['facebook'])
#     end
#   end
#
#   describe '.flagged_interactions' do
#     it 'returns array of campaign\'s posts\' flagged interactions' do
#       campaign = FactoryGirl.create(:campaign)
#       facebook_post = FactoryGirl.create(:post, campaign: campaign)
#       4.times do
#         FactoryGirl.create(:comment, post: facebook_post, network_comment_id: Faker::Number.number(10))
#       end
#       5.times do
#         FactoryGirl.create(:reaction, post: facebook_post, network_user_id: Faker::Number.number(10))
#       end
#       comments = [
#         FactoryGirl.create(:comment, post: facebook_post, network_comment_id: Faker::Number.number(10), flagged: true),
#         FactoryGirl.create(:comment, post: facebook_post, network_comment_id: Faker::Number.number(10), flagged: true)
#       ]
#       reactions = [
#         FactoryGirl.create(:reaction, post: facebook_post, network_user_id: Faker::Number.number(10), flagged: true),
#         FactoryGirl.create(:reaction, post: facebook_post, network_user_id: Faker::Number.number(10), flagged: true),
#         FactoryGirl.create(:reaction, post: facebook_post, network_user_id: Faker::Number.number(10), flagged: true)
#       ]
#
#       expect(campaign.flagged_interactions).to eql(comments.sort + reactions.sort)
#       expect(campaign.flagged_interactions.count).to eql(5)
#     end
#   end
# end
