require 'rails_helper'

RSpec.describe 'posts/new', type: :view do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    assign(:post, Post.new(
      :network => nil,
      :network_post_id => 'MyString',
      :network_parent_id => 'MyString'
    ))
    sign_in(user)
  end

  it 'renders new post form' do
    render

    assert_select 'form[action=?][method=?]', posts_path, 'post' do

      assert_select 'input#post_name[name=?]', 'post[name]'

      assert_select 'input#post_network_post_id[name=?]', 'post[network_post_id]'

      assert_select 'input#post_network_parent_id[name=?]', 'post[network_parent_id]'
    end
  end
end
