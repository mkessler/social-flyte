require 'rails_helper'

RSpec.describe Post, type: :model do
  ActiveJob::Base.queue_adapter = :test

  let(:user) { FactoryGirl.create(:user) }
  let(:post) { FactoryGirl.create(:post) }

  describe 'associations' do
    it 'belongs to user' do
      expect(Post.reflect_on_association(:user).macro).to eql(:belongs_to)
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

    it 'has many shares' do
      expect(Post.reflect_on_association(:shares).macro).to eql(:has_many)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(
        :post,
        user_id: user.id
      )
      post = Post.new(valid_attributes)

      expect(post).to be_valid
    end

    it 'is not valid with valid with missing network_parent_id for facebook' do
      valid_attributes = FactoryGirl.attributes_for(
        :post,
        user_id: user.id,
        network_parent_id: nil
      )
      post = Post.new(valid_attributes)

      expect(post).to_not be_valid
    end

    it 'is not valid with missing user' do
      invalid_attributes = FactoryGirl.attributes_for(
        :post,
        user_id: nil
      )
      post = Post.new(invalid_attributes)

      expect(post).to_not be_valid
    end

    it 'is not valid with missing name' do
      invalid_attributes = FactoryGirl.attributes_for(
        :post,
        name: nil
      )
      post = Post.new(invalid_attributes)

      expect(post).to_not be_valid
    end

    it 'is not valid with missing network' do
      invalid_attributes = FactoryGirl.attributes_for(
        :post,
        user_id: user.id,
        network_id: nil
      )
      post = Post.new(invalid_attributes)

      expect(post).to_not be_valid
    end

    it 'is not valid with missing network_post_id' do
      invalid_attributes = FactoryGirl.attributes_for(
        :post,
        user_id: user.id,
        network_post_id: nil
      )
      post = Post.new(invalid_attributes)

      expect(post).to_not be_valid
    end

    it 'is not valid if post with network_post_id already exists within user' do
      FactoryGirl.create(
        :post,
        user_id: user.id,
        network_post_id: '1234'
      )
      invalid_attributes = FactoryGirl.attributes_for(
        :post,
        user_id: user.id,
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

  describe '.can_be_synced?' do
    context 'synced within last 15 minutes' do
      it 'returns false' do
        post.synced_at = Time.now.utc
        post.save
        post.reload
        expect(post.can_be_synced?).to be false

        post.synced_at = Time.now.utc - 5.minutes
        post.save
        post.reload
        expect(post.can_be_synced?).to be false

        post.synced_at = Time.now.utc - 14.minutes
        post.save
        post.reload
        expect(post.can_be_synced?).to be false
      end
    end

    context 'synced longer than 15 minutes ago' do
      it 'returns true' do
        post.synced_at = Time.now.utc - 15.minutes
        post.save
        post.reload
        expect(post.can_be_synced?).to be true

        post.synced_at = Time.now.utc - 3.months
        post.save
        post.reload
        expect(post.can_be_synced?).to be true
      end
    end
  end

  describe '.sync' do
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

  describe '.update_sync_status' do
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
