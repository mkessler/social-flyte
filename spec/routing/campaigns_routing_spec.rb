require 'rails_helper'

RSpec.describe CampaignsController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(:get => '/o/1/campaigns').to route_to('campaigns#index', organization_id: '1')
    end

    it 'routes to #new' do
      expect(:get => '/o/1/campaigns/new').to route_to('campaigns#new', organization_id: '1')
    end

    it 'routes to #show' do
      expect(:get => '/o/1/campaigns/1').to route_to('campaigns#show', :id => '1', organization_id: '1')
    end

    it 'routes to #edit' do
      expect(:get => '/o/1/campaigns/1/edit').to route_to('campaigns#edit', :id => '1', organization_id: '1')
    end

    it 'routes to #create' do
      expect(:post => '/o/1/campaigns').to route_to('campaigns#create', organization_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(:put => '/o/1/campaigns/1').to route_to('campaigns#update', :id => '1', organization_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(:patch => '/o/1/campaigns/1').to route_to('campaigns#update', :id => '1', organization_id: '1')
    end

    it 'routes to #destroy' do
      expect(:delete => '/o/1/campaigns/1').to route_to('campaigns#destroy', :id => '1', organization_id: '1')
    end

  end
end
