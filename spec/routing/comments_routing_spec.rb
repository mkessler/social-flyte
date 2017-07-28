require 'rails_helper'

RSpec.describe CommentsController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(:get => 'posts/1/comments').to route_to('comments#index', post_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(:put => 'posts/1/comments/1').to route_to('comments#update', :id => '1', post_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(:patch => 'posts/1/comments/1').to route_to('comments#update', :id => '1', post_id: '1')
    end

  end
end
