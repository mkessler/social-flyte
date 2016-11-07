require 'rails_helper'

RSpec.describe 'posts/index', type: :view do
  before(:each) do
    assign(:posts, [
      FactoryGirl.create(:post),
      FactoryGirl.create(:post)
    ])
  end

  it 'renders a list of posts' do
    render
    #assert_select 'tr>td', :text => nil.to_s, :count => 2
    # assert_select 'tr>td', :text => 'Network Post'.to_s, :count => 2
    # assert_select 'tr>td', :text => 'Network Parent'.to_s, :count => 2
  end
end
