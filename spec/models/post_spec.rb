require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it 'belongs to campaign' do
      expect(Post.reflect_on_association(:campaign).macro).to eql(:belongs_to)
    end

    it 'belongs to network' do
      expect(Post.reflect_on_association(:network).macro).to eql(:belongs_to)
    end

    it 'has many reactions' do
      expect(Post.reflect_on_association(:reactions).macro).to eql(:has_many)
    end

    it 'has many comments' do
      expect(Post.reflect_on_association(:comments).macro).to eql(:has_many)
    end
  end

  describe 'validations' do
    before(:each) do
      @campaign = FactoryGirl.create(:campaign)
    end

    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(
        :post,
        campaign_id: @campaign.id
      )
      post = Post.new(valid_attributes)

      expect(post).to be_valid
    end

    # it 'is valid with valid with missing network_parent_id' do
    #   valid_attributes = FactoryGirl.attributes_for(
    #     :post,
    #     campaign_id: @campaign.id,
    #     network_parent_id: nil
    #   )
    #   post = Post.new(valid_attributes)
    #
    #   expect(post).to be_valid
    # end

    it 'is not valid with missing campaign' do
      invalid_attributes = FactoryGirl.attributes_for(
        :post,
        campaign_id: nil
      )
      post = Post.new(invalid_attributes)

      expect(post).to_not be_valid
    end

    it 'is not valid with missing network' do
      invalid_attributes = FactoryGirl.attributes_for(
        :post,
        campaign_id: @campaign.id,
        network_id: nil
      )
      post = Post.new(invalid_attributes)

      expect(post).to_not be_valid
    end

    it 'is not valid with missing network_post_id' do
      invalid_attributes = FactoryGirl.attributes_for(
        :post,
        campaign_id: @campaign.id,
        network_post_id: nil
      )
      post = Post.new(invalid_attributes)

      expect(post).to_not be_valid
    end

    it 'is not valid if post with network_post_id already exists within campaign' do
      FactoryGirl.create(
        :post,
        campaign_id: @campaign.id,
        network_post_id: '1234'
      )
      invalid_attributes = FactoryGirl.attributes_for(
        :post,
        campaign_id: @campaign.id,
        network_post_id: '1234'
      )
      post = Post.new(invalid_attributes)

      expect(post).to_not be_valid
    end
  end
end
