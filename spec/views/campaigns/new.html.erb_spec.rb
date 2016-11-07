require 'rails_helper'

RSpec.describe 'campaigns/new', type: :view do
  before(:each) do
    assign(:campaign, Campaign.new(FactoryGirl.attributes_for(:campaign)))
  end

  it 'renders new campaign form' do
    render

    assert_select 'form[action=?][method=?]', campaigns_path, 'post' do

      assert_select 'input#campaign_organization_id[name=?]', 'campaign[organization_id]'

      assert_select 'input#campaign_name[name=?]', 'campaign[name]'

      assert_select 'input#campaign_slug[name=?]', 'campaign[slug]'
    end
  end
end
