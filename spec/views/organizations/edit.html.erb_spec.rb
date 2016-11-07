require 'rails_helper'

RSpec.describe 'organizations/edit', type: :view do
  before(:each) do
    @organization = assign(:organization, FactoryGirl.create(:organization))
  end

  it 'renders the edit organization form' do
    render

    assert_select 'form[action=?][method=?]', organization_path(@organization), 'post' do

      assert_select 'input#organization_name[name=?]', 'organization[name]'

      assert_select 'input#organization_slug[name=?]', 'organization[slug]'
    end
  end
end
