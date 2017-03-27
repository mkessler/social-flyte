require 'rails_helper'

RSpec.describe SyncPostJob, type: :job do
  let(:user) { FactoryGirl.create(:user) }
  let(:facebook_token) { FactoryGirl.create(:facebook_token, user: user) }
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
          facebook_token
          SyncPostJob.perform_now(post, user)
          expect(post.reactions).to exist
        end
      end

      it 'aggregates and builds post comments' do
        VCR.use_cassette('facebook_sync_post_job') do
          facebook_token
          SyncPostJob.perform_now(post, user)
          expect(post.comments).to exist
        end
      end

      it 'updates post.synced_at' do
        VCR.use_cassette('facebook_sync_post_job') do
          facebook_token
          synced_at = post.synced_at
          SyncPostJob.perform_now(post, user)
          expect(post.reload.synced_at).to_not eq(synced_at)
        end
      end

      it 'updates post.sync_count' do
        VCR.use_cassette('facebook_sync_post_job') do
          facebook_token
          sync_count = post.sync_count
          expect{
            SyncPostJob.perform_now(post, user)
          }.to change{post.sync_count}.from(sync_count).to(sync_count + 1)
        end
      end
    end
  end
end
