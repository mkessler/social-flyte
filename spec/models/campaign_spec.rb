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

    it 'is not valid when campaign with same slug already exists within organization' do
      organization = FactoryGirl.create(:organization)
      FactoryGirl.create(
        :campaign,
        organization: organization,
        slug: 'summer-sale-contest'
      )
      campaign = Campaign.new(
        organization: organization,
        slug: 'summer-sale-contest'
      )

      expect(campaign).to_not be_valid
    end
  end

  describe ".engagement_count" do
    it 'returns the total number of post interactions' do
      campaign = FactoryGirl.create(:campaign)
      post = FactoryGirl.create(:post, campaign: campaign)
      post_two = FactoryGirl.create(:post, campaign: campaign, network_post_id: Faker::Number.number(10))

      10.times do
        FactoryGirl.create(:comment, network_comment_id: Faker::Number.number(10), post: post)
      end
      4.times do
        FactoryGirl.create(:reaction, network_user_id: Faker::Number.number(10),post: post)
      end

      5.times do
        FactoryGirl.create(:comment, network_comment_id: Faker::Number.number(10), post: post)
      end
      8.times do
        FactoryGirl.create(:reaction, network_user_id: Faker::Number.number(10),post: post)
      end

      expect(campaign.engagement_count).to eql(27)
    end
  end

  describe ".networks" do
    it 'returns an array of post networks' do
      campaign = FactoryGirl.create(:campaign)
      FactoryGirl.create(:post, campaign: campaign)
      FactoryGirl.create(:post, campaign: campaign, network: Network.twitter)
      FactoryGirl.create(:post, campaign: campaign, network: Network.instagram)

      expect(campaign.networks).to eql(['facebook', 'twitter', 'instagram'])
    end
  end
end
