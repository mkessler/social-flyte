require 'rails_helper'

RSpec.describe SyncPostJob, type: :job do
  let(:user) { FactoryGirl.create(:user) }
  let(:post) {
    FactoryGirl.create(
      :post,
      network_post_id: '958246924280290',
      network_parent_id: '564071993697787'
    )
  }
  let(:authentication) {
    FactoryGirl.create(
      :authentication,
      user: user,
      token: 'EAAXuaK0yoQIBAD1TqcWcO8hw57ze9PfdFyfFZAsyIRXOkYo5CbwnfJc1oDiFtbfEAbJ1PX61p524MbicZC0MbxPGOHYKOVvUfvNNsgn8qvbkYyUy6S0ZAZAZBOcbJf0ZCj6HybFA4iLxalhxEKcyt0kN9GOyuZChGsZD'
    )
  }

  before(:example) do
    authentication
  end

  describe '#perform' do
    context 'facebook' do
      it 'aggregates and builds post reactions' do
        VCR.use_cassette('facebook_sync_post_job') do
          SyncPostJob.perform_now(user, post)
          expect(post.reactions).to exist
        end
      end

      it 'aggregates and builds post comments' do
        VCR.use_cassette('facebook_sync_post_job') do
          SyncPostJob.perform_now(user, post)
          expect(post.comments).to exist
        end
      end

      it 'updates post.synced_at' do
        VCR.use_cassette('facebook_sync_post_job') do
          synced_at = post.synced_at
          SyncPostJob.perform_now(user, post)
          expect(post.reload.synced_at).to_not eq(synced_at)
        end
      end

      it 'updates post.sync_count' do
        VCR.use_cassette('facebook_sync_post_job') do
          sync_count = post.sync_count
          expect{
            SyncPostJob.perform_now(user, post)
          }.to change{post.sync_count}.from(sync_count).to(sync_count + 1)
        end
      end
    end
  end
end
