require 'rails_helper'

RSpec.describe 'campaigns/edit', type: :view do
  before(:each) do
    @organization = FactoryGirl.create(:organization)
    @campaign = assign(:campaign, FactoryGirl.create(
      :campaign,
      organization: @organization
    ))
  end

  it 'renders the edit campaign form' do
    render

    assert_select 'form[action=?][method=?]', organization_campaign_path(@organization, @campaign), 'post' do

      assert_select 'input#campaign_name[name=?]', 'campaign[name]'

    end
  end
end
