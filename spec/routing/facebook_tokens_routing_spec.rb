require "rails_helper"

RSpec.describe FacebookTokensController, type: :routing do
  describe "routing" do

    it "routes to #show" do
      expect(:get => "/facebook_tokens/1.json").to route_to("facebook_tokens#show", :id => "1", format: 'json')
    end

    it "routes to #create_or_update" do
      expect(:post => "/facebook_tokens/create_or_update.json").to route_to("facebook_tokens#create_or_update", format: 'json')
    end

    it "routes to #create" do
      expect(:post => "/facebook_tokens.json").to route_to("facebook_tokens#create", format: 'json')
    end

    it "routes to #update via PUT" do
      expect(:put => "/facebook_tokens/1.json").to route_to("facebook_tokens#update", :id => "1", format: 'json')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/facebook_tokens/1.json").to route_to("facebook_tokens#update", :id => "1", format: 'json')
    end

    it "routes to #destroy" do
      expect(:delete => "/facebook_tokens/1.json").to route_to("facebook_tokens#destroy", :id => "1", format: 'json')
    end

  end
end
