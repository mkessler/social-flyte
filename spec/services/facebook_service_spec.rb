require 'rails_helper'

RSpec.describe FacebookService, type: :service do
  let(:user) { FactoryGirl.create(:user) }
  let(:facebook_token) { FactoryGirl.create(:facebook_token, user: user) }
  let(:post) {
    FactoryGirl.create(
      :post,
      network_post_id: '958246924280290',
      network_parent_id: '564071993697787'
    )
  }
  let(:service) { FacebookService.new(user, post) }

  describe 'initialize' do
    it 'creates a new service object' do
      VCR.use_cassette('facebook_service_sync') do
        facebook_token
        expect(service).to be_truthy
      end
    end
  end

  describe 'sync' do
    it 'returns post data' do
      VCR.use_cassette('facebook_service_sync') do
        facebook_token
        response = service.sync
        expect(response).to be_truthy
      end
    end
  end
end
