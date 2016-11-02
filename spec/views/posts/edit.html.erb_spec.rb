require 'rails_helper'

RSpec.describe "posts/edit", type: :view do
  before(:each) do
    @post = assign(:post, Post.create!(
      :network => nil,
      :network_post_id => "MyString",
      :network_parent_id => "MyString"
    ))
  end

  it "renders the edit post form" do
    render

    assert_select "form[action=?][method=?]", post_path(@post), "post" do

      assert_select "input#post_network_id[name=?]", "post[network_id]"

      assert_select "input#post_network_post_id[name=?]", "post[network_post_id]"

      assert_select "input#post_network_parent_id[name=?]", "post[network_parent_id]"
    end
  end
end
