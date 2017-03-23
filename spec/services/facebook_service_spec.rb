require 'rails_helper'

RSpec.describe FacebookService, type: :service do
  let(:user) { FactoryGirl.create(:user) }
  let(:token) { 'EAAYWqqyPLBQBAFnUNvLbg8Pt2Fe3C0uoTygN65rYYgRxkc4OjQHiAqaSzQyh2FDygbx8EHlh0CpfrOoFYG21536nX40MsCPZCHzGZARTJrtHwrxvrpNwemuCgwxm3ea0ac3xQbruBsZCxeAG60qpi5x49hH7gMfVYNyNNK9pOC7nZA8ZCanNtIYhqOL5Vzi4ZD' }
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
      expect(service).to be_truthy
    end
  end

  describe 'sync' do
    it 'returns post data' do
      VCR.use_cassette('facebook_service_sync') do
        response = service.sync
        expect(response).to be_truthy
      end
    end
  end
end
