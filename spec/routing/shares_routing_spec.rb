require 'rails_helper'

RSpec.describe SharesController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(:get => 'posts/1/shares').to route_to('shares#index', post_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(:put => 'posts/1/shares/1').to route_to('shares#update', :id => '1', post_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(:patch => 'posts/1/shares/1').to route_to('shares#update', :id => '1', post_id: '1')
    end

  end
end
