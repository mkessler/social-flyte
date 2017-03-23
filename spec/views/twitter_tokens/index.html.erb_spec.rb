require 'rails_helper'

RSpec.describe "twitter_tokens/index", type: :view do
  before(:each) do
    assign(:twitter_tokens, [
      TwitterToken.create!(
        :organization => nil,
        :encrypted_token => "Encrypted Token",
        :encrypted_secret => "Encrypted Secret",
        :encrypted_token_iv => "Encrypted Token Iv",
        :encrypted_secret_iv => "Encrypted Secret Iv",
        :network_user_id => "Network User",
        :network_user_name => "Network User Name",
        :network_user_image_url => "Network User Image Url"
      ),
      TwitterToken.create!(
        :organization => nil,
        :encrypted_token => "Encrypted Token",
        :encrypted_secret => "Encrypted Secret",
        :encrypted_token_iv => "Encrypted Token Iv",
        :encrypted_secret_iv => "Encrypted Secret Iv",
        :network_user_id => "Network User",
        :network_user_name => "Network User Name",
        :network_user_image_url => "Network User Image Url"
      )
    ])
  end

  it "renders a list of twitter_tokens" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Encrypted Token".to_s, :count => 2
    assert_select "tr>td", :text => "Encrypted Secret".to_s, :count => 2
    assert_select "tr>td", :text => "Encrypted Token Iv".to_s, :count => 2
    assert_select "tr>td", :text => "Encrypted Secret Iv".to_s, :count => 2
    assert_select "tr>td", :text => "Network User".to_s, :count => 2
    assert_select "tr>td", :text => "Network User Name".to_s, :count => 2
    assert_select "tr>td", :text => "Network User Image Url".to_s, :count => 2
  end
end
