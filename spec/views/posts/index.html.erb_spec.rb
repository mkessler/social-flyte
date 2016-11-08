require 'rails_helper'

RSpec.describe 'posts/index', type: :view do
  before(:each) do
    @organization = FactoryGirl.create(:organization)
    @campaign = FactoryGirl.create(
      :campaign,
      organization: @organization
    )
    assign(:posts, [
      FactoryGirl.create(
        :post,
        campaign: @campaign,
        network_post_id: '1234'
      ),
      FactoryGirl.create(
        :post,
        campaign: @campaign,
        network_post_id: '5678'
      )
    ])
  end

  it 'renders a list of posts' do
    render
    #assert_select 'tr>td', :text => nil.to_s, :count => 2
    # assert_select 'tr>td', :text => 'Network Post'.to_s, :count => 2
    # assert_select 'tr>td', :text => 'Network Parent'.to_s, :count => 2
  end
end
