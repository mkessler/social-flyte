require 'rails_helper'

RSpec.describe "facebook_tokens/show", type: :view do
  before(:each) do
    @facebook_token = assign(:facebook_token, FacebookToken.create!(
      :user => nil,
      :encrypted_token => "Encrypted Token",
      :encrypted_token_iv => "Encrypted Token Iv",
      :network_user_id => "Network User",
      :network_user_name => "Network User Name",
      :network_user_image_url => "Network User Image Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Encrypted Token/)
    expect(rendered).to match(/Encrypted Token Iv/)
    expect(rendered).to match(/Network User/)
    expect(rendered).to match(/Network User Name/)
    expect(rendered).to match(/Network User Image Url/)
  end
end
