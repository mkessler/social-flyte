require 'rails_helper'

RSpec.describe 'campaigns/edit', type: :view do
  before(:each) do
    @campaign = assign(:campaign, FactoryGirl.create(
      :campaign,
      organization: FactoryGirl.create(:organization)
    ))
  end

  it 'renders the edit campaign form' do
    render

    assert_select 'form[action=?][method=?]', campaign_path(@campaign), 'post' do

      assert_select 'input#campaign_organization_id[name=?]', 'campaign[organization_id]'

      assert_select 'input#campaign_name[name=?]', 'campaign[name]'

      assert_select 'input#campaign_slug[name=?]', 'campaign[slug]'
    end
  end
end
