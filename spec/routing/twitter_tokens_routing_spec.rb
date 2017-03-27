require "rails_helper"

RSpec.describe TwitterTokensController, type: :routing do
  describe "routing" do

    it "routes to #show" do
      expect(:get => "/twitter_tokens/1.json").to route_to("twitter_tokens#show", :id => "1", format: 'json')
    end

    it "routes to #create" do
      expect(:post => "/twitter_tokens").to route_to("twitter_tokens#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/twitter_tokens/1").to route_to("twitter_tokens#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/twitter_tokens/1").to route_to("twitter_tokens#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/twitter_tokens/1").to route_to("twitter_tokens#destroy", :id => "1")
    end

  end
end
