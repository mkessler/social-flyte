require 'rails_helper'

RSpec.describe Post, type: :model do
  ActiveJob::Base.queue_adapter = :test
  let(:user) { FactoryGirl.create(:user) }
  let(:post) { FactoryGirl.create(:post) }
  let(:campaign) { FactoryGirl.create(:campaign) }

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
      campaign = FactoryGirl.create(:campaign)
    end

    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(
        :post,
        campaign_id: campaign.id
      )
      post = Post.new(valid_attributes)

      expect(post).to be_valid
    end

    # it 'is valid with valid with missing network_parent_id' do
    #   valid_attributes = FactoryGirl.attributes_for(
    #     :post,
    #     campaign_id: campaign.id,
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
        campaign_id: campaign.id,
        network_id: nil
      )
      post = Post.new(invalid_attributes)

      expect(post).to_not be_valid
    end

    it 'is not valid with missing network_post_id' do
      invalid_attributes = FactoryGirl.attributes_for(
        :post,
        campaign_id: campaign.id,
        network_post_id: nil
      )
      post = Post.new(invalid_attributes)

      expect(post).to_not be_valid
    end

    it 'is not valid if post with network_post_id already exists within campaign' do
      FactoryGirl.create(
        :post,
        campaign_id: campaign.id,
        network_post_id: '1234'
      )
      invalid_attributes = FactoryGirl.attributes_for(
        :post,
        campaign_id: campaign.id,
        network_post_id: '1234'
      )
      post = Post.new(invalid_attributes)

      expect(post).to_not be_valid
    end
  end

  describe '.engagement_count' do
    context 'facebook' do
      it 'returns the total number of comments and reactions' do
        10.times do
          FactoryGirl.create(:comment, post: post, network_comment_id: Faker::Number.number(10))
        end
        4.times do
          FactoryGirl.create(:reaction, post: post, network_user_id: Faker::Number.number(10))
        end

        expect(post.engagement_count).to eql(14)
      end
    end
  end

  describe '.engagement_types' do
    context 'facebook' do
      it 'returns comments and reactions' do
        expect(post.engagement_types).to eql('Comments & Reactions')
      end
    end
  end

  describe '.flagged_interactions' do
    context 'facebook' do
      it 'returns array of comments and reactions' do
        4.times do
          FactoryGirl.create(:comment, post: post, network_comment_id: Faker::Number.number(10))
        end
        5.times do
          FactoryGirl.create(:reaction, post: post, network_user_id: Faker::Number.number(10))
        end
        comments = [
          FactoryGirl.create(:comment, post: post, network_comment_id: Faker::Number.number(10), flagged: true),
          FactoryGirl.create(:comment, post: post, network_comment_id: Faker::Number.number(10), flagged: true)
        ]
        reactions = [
          FactoryGirl.create(:reaction, post: post, network_user_id: Faker::Number.number(10), flagged: true),
          FactoryGirl.create(:reaction, post: post, network_user_id: Faker::Number.number(10), flagged: true),
          FactoryGirl.create(:reaction, post: post, network_user_id: Faker::Number.number(10), flagged: true)
        ]

        expect(post.flagged_interactions).to eql(comments.sort + reactions.sort)
        expect(post.flagged_interactions.count).to eql(5)
      end
    end
  end

  describe 'sync' do
    it 'enqueues post sync job' do
      expect{post.sync(user)}.to have_enqueued_job(SyncPostJob)
    end

    it 'updates job id' do
      job_id = post.job_id
      post.sync(user)
      expect(post.job_id).to be_truthy
      expect(post.job_id).to_not eql(job_id)
    end
  end

  describe 'update_sync_status' do
    it 'updates synced_at timestamp' do
      sync_time = post.synced_at
      post.update_sync_status
      expect(post.synced_at).to be > sync_time
    end

    it 'updates sync count by 1' do
      expect{post.update_sync_status}.to change{post.sync_count}.by(1)
    end
  end
end
