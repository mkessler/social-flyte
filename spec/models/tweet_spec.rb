require 'rails_helper'

RSpec.describe Tweet, type: :model do
  let(:post) { FactoryGirl.create(:post) }

  describe 'associations' do
    it 'belongs to post' do
      expect(Tweet.reflect_on_association(:post).macro).to eql(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(
        :tweet,
        post_id: post.id
      )
      tweet = Tweet.new(valid_attributes)

      expect(tweet).to be_valid
    end

    it 'is not valid with missing post' do
      invalid_attributes = FactoryGirl.attributes_for(
        :tweet,
        post_id: nil
      )
      tweet = Tweet.new(invalid_attributes)

      expect(tweet).to_not be_valid
    end

    it 'is not valid with missing network_tweet_id' do
      invalid_attributes = FactoryGirl.attributes_for(
        :tweet,
        post_id: post.id,
        network_tweet_id: nil
      )
      tweet = Tweet.new(invalid_attributes)

      expect(tweet).to_not be_valid
    end

    it 'is not valid with missing network_user_id' do
      invalid_attributes = FactoryGirl.attributes_for(
        :tweet,
        post_id: post.id,
        network_user_id: nil
      )
      tweet = Tweet.new(invalid_attributes)

      expect(tweet).to_not be_valid
    end

    it 'is not valid with missing network_user_name' do
      invalid_attributes = FactoryGirl.attributes_for(
        :tweet,
        post_id: post.id,
        network_user_name: nil
      )
      tweet = Tweet.new(invalid_attributes)

      expect(tweet).to_not be_valid
    end

    it 'is not valid with missing network_user_screen_name' do
      invalid_attributes = FactoryGirl.attributes_for(
        :tweet,
        post_id: post.id,
        network_user_screen_name: nil
      )
      tweet = Tweet.new(invalid_attributes)

      expect(tweet).to_not be_valid
    end

    it 'is not valid with missing favorite_count' do
      invalid_attributes = FactoryGirl.attributes_for(
        :tweet,
        post_id: post.id,
        favorite_count: nil
      )
      tweet = Tweet.new(invalid_attributes)

      expect(tweet).to_not be_valid
    end

    it 'is not valid with missing retweet_count' do
      invalid_attributes = FactoryGirl.attributes_for(
        :tweet,
        post_id: post.id,
        retweet_count: nil
      )
      tweet = Tweet.new(invalid_attributes)

      expect(tweet).to_not be_valid
    end

    it 'is not valid with missing message' do
      invalid_attributes = FactoryGirl.attributes_for(
        :tweet,
        post_id: post.id,
        message: nil
      )
      tweet = Tweet.new(invalid_attributes)

      expect(tweet).to_not be_valid
    end

    it 'is not valid with missing posted_at' do
      invalid_attributes = FactoryGirl.attributes_for(
        :tweet,
        post_id: post.id,
        posted_at: nil
      )
      tweet = Tweet.new(invalid_attributes)

      expect(tweet).to_not be_valid
    end

    it 'is not valid if tweet with network_tweet_id already exists within post' do
      FactoryGirl.create(:tweet, post_id: post.id, network_tweet_id: '1234')
      invalid_attributes = FactoryGirl.attributes_for(
        :tweet,
        post_id: post.id,
        network_tweet_id: '1234'
      )
      tweet = Tweet.new(invalid_attributes)

      expect(tweet).to_not be_valid
    end
  end

  describe 'scope' do
    before(:context) do
      10.times { FactoryGirl.create(:tweet) }
      4.times { FactoryGirl.create(:tweet, flagged: true) }
    end

    describe 'flagged' do
      it 'should return only flagged tweets' do
        expect(Tweet.flagged).to eq(Tweet.where(flagged: true))
        expect(Tweet.flagged.count).to eql(4)
      end
    end
  end

  describe '.network_user_screen_name' do
    it 'preprends @ to screen name' do
      tweet = FactoryGirl.create(:tweet, network_user_screen_name: 'groala')
      expect(tweet.network_user_screen_name).to eql('@groala')
    end
  end
end
