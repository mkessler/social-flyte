require 'rails_helper'

RSpec.describe 'posts/new', type: :view do
  before(:each) do
    @organization = FactoryGirl.create(:organization)
    @campaign = FactoryGirl.create(:campaign)
    assign(:post, Post.new(
      :network => nil,
      :network_post_id => 'MyString',
      :network_parent_id => 'MyString'
    ))
  end

  it 'renders new post form' do
    render

    assert_select 'form[action=?][method=?]', organization_campaign_posts_path(@organization, @campaign), 'post' do

      assert_select 'input#post_network_id[name=?]', 'post[network_id]'

      assert_select 'input#post_network_post_id[name=?]', 'post[network_post_id]'

      assert_select 'input#post_network_parent_id[name=?]', 'post[network_parent_id]'
    end
  end
end
