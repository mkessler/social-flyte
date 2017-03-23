require 'rails_helper'

RSpec.describe "facebook_tokens/edit", type: :view do
  before(:each) do
    @facebook_token = assign(:facebook_token, FacebookToken.create!(
      :user => nil,
      :encrypted_token => "MyString",
      :encrypted_token_iv => "MyString",
      :network_user_id => "MyString",
      :network_user_name => "MyString",
      :network_user_image_url => "MyString"
    ))
  end

  it "renders the edit facebook_token form" do
    render

    assert_select "form[action=?][method=?]", facebook_token_path(@facebook_token), "post" do

      assert_select "input#facebook_token_user_id[name=?]", "facebook_token[user_id]"

      assert_select "input#facebook_token_encrypted_token[name=?]", "facebook_token[encrypted_token]"

      assert_select "input#facebook_token_encrypted_token_iv[name=?]", "facebook_token[encrypted_token_iv]"

      assert_select "input#facebook_token_network_user_id[name=?]", "facebook_token[network_user_id]"

      assert_select "input#facebook_token_network_user_name[name=?]", "facebook_token[network_user_name]"

      assert_select "input#facebook_token_network_user_image_url[name=?]", "facebook_token[network_user_image_url]"
    end
  end
end
