require 'rails_helper'

RSpec.describe FacebookService, type: :service do
  let(:user) { FactoryGirl.create(:user) }
  let(:token) { 'EAAXuaK0yoQIBAAis6UZBoMsQmZBN1mOwHmiEk41YF3wjyb3nDhrIk9nGfzoKUM2F832ZBHHse3buq9Av9XHn8GZBIKaPkfzSphMCLy0WtyyLTf1egq0YuFCnO5SkdKZCkP7ZB2KbYmQcfFqJZAMBxXKAplIqUwZBrOoUQPdqVjaEwZAZAGPel7HIG8K6vYugZB4g9UZD' }
  let(:post) {
    FactoryGirl.create(
      :post,
      network_post_id: '958246924280290',
      network_parent_id: '564071993697787'
    )
  }
  let(:service) { FacebookService.new(user, post, token) }

  describe 'initialize' do
    it 'creates a new service object' do
      expect(service).to be_truthy
    end
  end

  describe 'get_post' do
    it 'returns post data' do
      VCR.use_cassette('facebook_service_get_post') do
        response = service.get_post
        expect(response).to be_truthy
      end
    end
  end

  describe 'get_comments' do
    it 'returns comments data' do
      VCR.use_cassette('facebook_service_get_comments') do
        response = service.get_comments
        expect(response).to be_truthy
      end
    end
  end

  describe 'get_reactions' do
    it 'returns reactions data' do
      VCR.use_cassette('facebook_service_get_reactions') do
        response = service.get_reactions
        expect(response).to be_truthy
      end
    end
  end

  describe 'get_shares' do
    it 'returns shares data' do
      VCR.use_cassette('facebook_service_get_shares') do
        response = service.get_shares
        expect(response).to be_truthy
      end
    end
  end

  describe 'aggregate_reactions' do
    it 'creates reactions' do
      VCR.use_cassette('facebook_service_aggregate_reactions') do
        expect{service.aggregate_reactions}.to change(Reaction, :count)
      end
    end
  end

  describe 'aggregate_comments' do
    it 'creates comments' do
      VCR.use_cassette('facebook_service_aggregate_comments') do
        expect{service.aggregate_comments}.to change(Comment, :count)
      end
    end
  end
end
