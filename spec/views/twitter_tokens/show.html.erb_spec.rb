require 'rails_helper'

RSpec.describe "twitter_tokens/show", type: :view do
  before(:each) do
    @twitter_token = assign(:twitter_token, TwitterToken.create!(
      :organization => nil,
      :encrypted_token => "Encrypted Token",
      :encrypted_secret => "Encrypted Secret",
      :encrypted_token_iv => "Encrypted Token Iv",
      :encrypted_secret_iv => "Encrypted Secret Iv",
      :network_user_id => "Network User",
      :network_user_name => "Network User Name",
      :network_user_image_url => "Network User Image Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Encrypted Token/)
    expect(rendered).to match(/Encrypted Secret/)
    expect(rendered).to match(/Encrypted Token Iv/)
    expect(rendered).to match(/Encrypted Secret Iv/)
    expect(rendered).to match(/Network User/)
    expect(rendered).to match(/Network User Name/)
    expect(rendered).to match(/Network User Image Url/)
  end
end
