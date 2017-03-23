require 'rails_helper'

RSpec.describe "facebook_tokens/index", type: :view do
  before(:each) do
    assign(:facebook_tokens, [
      FacebookToken.create!(
        :user => nil,
        :encrypted_token => "Encrypted Token",
        :encrypted_token_iv => "Encrypted Token Iv",
        :network_user_id => "Network User",
        :network_user_name => "Network User Name",
        :network_user_image_url => "Network User Image Url"
      ),
      FacebookToken.create!(
        :user => nil,
        :encrypted_token => "Encrypted Token",
        :encrypted_token_iv => "Encrypted Token Iv",
        :network_user_id => "Network User",
        :network_user_name => "Network User Name",
        :network_user_image_url => "Network User Image Url"
      )
    ])
  end

  it "renders a list of facebook_tokens" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Encrypted Token".to_s, :count => 2
    assert_select "tr>td", :text => "Encrypted Token Iv".to_s, :count => 2
    assert_select "tr>td", :text => "Network User".to_s, :count => 2
    assert_select "tr>td", :text => "Network User Name".to_s, :count => 2
    assert_select "tr>td", :text => "Network User Image Url".to_s, :count => 2
  end
end
