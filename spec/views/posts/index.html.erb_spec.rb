require 'rails_helper'

RSpec.describe "posts/index", type: :view do
  before(:each) do
    assign(:posts, [
      Post.create!(
        :network => Network.facebook,
        :network_post_id => "Network Post",
        :network_parent_id => "Network Parent"
      ),
      Post.create!(
        :network => Network.twitter,
        :network_post_id => "Network Post",
        :network_parent_id => "Network Parent"
      )
    ])
  end

  it "renders a list of posts" do
    render
    #assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Network Post".to_s, :count => 2
    assert_select "tr>td", :text => "Network Parent".to_s, :count => 2
  end
end
