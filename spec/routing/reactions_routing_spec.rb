require 'rails_helper'

RSpec.describe ReactionsController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(:get => 'posts/1/reactions').to route_to('reactions#index', post_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(:put => 'posts/1/reactions/1').to route_to('reactions#update', :id => '1', post_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(:patch => 'posts/1/reactions/1').to route_to('reactions#update', :id => '1', post_id: '1')
    end

  end
end
