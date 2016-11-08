require 'rails_helper'

RSpec.describe PostsController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(:get => '/organizations/1/campaigns/1/posts').to route_to('posts#index', organization_id: '1', campaign_id: '1')
    end

    it 'routes to #new' do
      expect(:get => '/organizations/1/campaigns/1/posts/new').to route_to('posts#new', organization_id: '1', campaign_id: '1')
    end

    it 'routes to #show' do
      expect(:get => '/organizations/1/campaigns/1/posts/1').to route_to('posts#show', :id => '1', organization_id: '1', campaign_id: '1')
    end

    it 'routes to #create' do
      expect(:post => '/organizations/1/campaigns/1/posts').to route_to('posts#create', organization_id: '1', campaign_id: '1')
    end

    it 'routes to #destroy' do
      expect(:delete => '/organizations/1/campaigns/1/posts/1').to route_to('posts#destroy', :id => '1', organization_id: '1', campaign_id: '1')
    end

  end
end
