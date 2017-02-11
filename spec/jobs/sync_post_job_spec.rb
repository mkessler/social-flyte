require 'rails_helper'

RSpec.describe SyncPostJob, type: :job do
  let(:user) { FactoryGirl.create(:user) }
  let(:token) { 'EAAXuaK0yoQIBAAis6UZBoMsQmZBN1mOwHmiEk41YF3wjyb3nDhrIk9nGfzoKUM2F832ZBHHse3buq9Av9XHn8GZBIKaPkfzSphMCLy0WtyyLTf1egq0YuFCnO5SkdKZCkP7ZB2KbYmQcfFqJZAMBxXKAplIqUwZBrOoUQPdqVjaEwZAZAGPel7HIG8K6vYugZB4g9UZD' }
  let(:post) {
    FactoryGirl.create(
      :post,
      network_post_id: '958246924280290',
      network_parent_id: '564071993697787'
    )
  }

  describe '#perform' do
    context 'facebook' do
      it 'aggregates and builds post reactions' do
        VCR.use_cassette('facebook_sync_post_job') do
          SyncPostJob.perform_now(user, post, token)
          expect(post.reactions).to exist
        end
      end

      it 'aggregates and builds post comments' do
        VCR.use_cassette('facebook_sync_post_job') do
          SyncPostJob.perform_now(user, post, token)
          expect(post.comments).to exist
        end
      end

      it 'updates post.synced_at' do
        VCR.use_cassette('facebook_sync_post_job') do
          synced_at = post.synced_at
          SyncPostJob.perform_now(user, post, token)
          expect(post.reload.synced_at).to_not eq(synced_at)
        end
      end

      it 'updates post.sync_count' do
        VCR.use_cassette('facebook_sync_post_job') do
          sync_count = post.sync_count
          expect{
            SyncPostJob.perform_now(user, post, token)
          }.to change{post.sync_count}.from(sync_count).to(sync_count + 1)
        end
      end
    end
  end
end
