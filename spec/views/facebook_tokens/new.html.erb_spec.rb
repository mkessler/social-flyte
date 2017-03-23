require 'rails_helper'

RSpec.describe "facebook_tokens/new", type: :view do
  before(:each) do
    assign(:facebook_token, FacebookToken.new(
      :user => nil,
      :encrypted_token => "MyString",
      :encrypted_token_iv => "MyString",
      :network_user_id => "MyString",
      :network_user_name => "MyString",
      :network_user_image_url => "MyString"
    ))
  end

  it "renders new facebook_token form" do
    render

    assert_select "form[action=?][method=?]", facebook_tokens_path, "post" do

      assert_select "input#facebook_token_user_id[name=?]", "facebook_token[user_id]"

      assert_select "input#facebook_token_encrypted_token[name=?]", "facebook_token[encrypted_token]"

      assert_select "input#facebook_token_encrypted_token_iv[name=?]", "facebook_token[encrypted_token_iv]"

      assert_select "input#facebook_token_network_user_id[name=?]", "facebook_token[network_user_id]"

      assert_select "input#facebook_token_network_user_name[name=?]", "facebook_token[network_user_name]"

      assert_select "input#facebook_token_network_user_image_url[name=?]", "facebook_token[network_user_image_url]"
    end
  end
end
