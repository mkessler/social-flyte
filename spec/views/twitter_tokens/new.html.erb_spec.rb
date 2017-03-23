require 'rails_helper'

RSpec.describe "twitter_tokens/new", type: :view do
  before(:each) do
    assign(:twitter_token, TwitterToken.new(
      :organization => nil,
      :encrypted_token => "MyString",
      :encrypted_secret => "MyString",
      :encrypted_token_iv => "MyString",
      :encrypted_secret_iv => "MyString",
      :network_user_id => "MyString",
      :network_user_name => "MyString",
      :network_user_image_url => "MyString"
    ))
  end

  it "renders new twitter_token form" do
    render

    assert_select "form[action=?][method=?]", twitter_tokens_path, "post" do

      assert_select "input#twitter_token_organization_id[name=?]", "twitter_token[organization_id]"

      assert_select "input#twitter_token_encrypted_token[name=?]", "twitter_token[encrypted_token]"

      assert_select "input#twitter_token_encrypted_secret[name=?]", "twitter_token[encrypted_secret]"

      assert_select "input#twitter_token_encrypted_token_iv[name=?]", "twitter_token[encrypted_token_iv]"

      assert_select "input#twitter_token_encrypted_secret_iv[name=?]", "twitter_token[encrypted_secret_iv]"

      assert_select "input#twitter_token_network_user_id[name=?]", "twitter_token[network_user_id]"

      assert_select "input#twitter_token_network_user_name[name=?]", "twitter_token[network_user_name]"

      assert_select "input#twitter_token_network_user_image_url[name=?]", "twitter_token[network_user_image_url]"
    end
  end
end
