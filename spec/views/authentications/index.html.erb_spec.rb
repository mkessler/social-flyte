require 'rails_helper'

RSpec.describe "authentications/index", type: :view do
  before(:each) do
    assign(:authentications, [
      Authentication.create!(
        :user_id => 2,
        :provider => "Provider",
        :uid => "Uid",
        :oauth_token => "Oauth Token"
      ),
      Authentication.create!(
        :user_id => 2,
        :provider => "Provider",
        :uid => "Uid",
        :oauth_token => "Oauth Token"
      )
    ])
  end

  it "renders a list of authentications" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Provider".to_s, :count => 2
    assert_select "tr>td", :text => "Uid".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Oauth Token".to_s, :count => 2
  end
end
