require 'rails_helper'

RSpec.describe PostsController, type: :routing do
  describe 'routing' do

    it 'routes to #new' do
      expect(:get => '/o/1/c/1/p/new').to route_to('posts#new', organization_id: '1', campaign_id: '1')
    end

    it 'routes to #show' do
      expect(:get => '/o/1/c/1/p/1').to route_to('posts#show', :id => '1', organization_id: '1', campaign_id: '1')
    end

    it 'routes to #create' do
      expect(:post => '/o/1/c/1/p').to route_to('posts#create', organization_id: '1', campaign_id: '1')
    end

    it 'routes to #destroy' do
      expect(:delete => '/o/1/c/1/p/1').to route_to('posts#destroy', :id => '1', organization_id: '1', campaign_id: '1')
    end

  end
end
