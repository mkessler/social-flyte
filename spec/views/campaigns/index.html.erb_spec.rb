require 'rails_helper'

RSpec.describe 'campaigns/index', type: :view do
  before(:each) do
    @organization = FactoryGirl.create(:organization)
    assign(:campaigns, [
      FactoryGirl.create(
        :campaign,
        organization: @organization,
        name: 'Summer Sale Contest'
      ),
      FactoryGirl.create(
        :campaign,
        organization: @organization,
        name: 'Winter Sale Contest'
      )
    ])
  end

  it 'renders a list of campaigns' do
    render
    # assert_select 'tr>td', :text => nil.to_s, :count => 2
    # assert_select 'tr>td', :text => 'Name'.to_s, :count => 2
    # assert_select 'tr>td', :text => 'Slug'.to_s, :count => 2
  end
end
