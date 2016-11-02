require 'rails_helper'

RSpec.describe "posts/show", type: :view do
  before(:each) do
    @post = assign(:post, Post.create!(
      :network => nil,
      :network_post_id => "Network Post",
      :network_parent_id => "Network Parent"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Network Post/)
    expect(rendered).to match(/Network Parent/)
  end
end
