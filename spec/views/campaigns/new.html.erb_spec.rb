# require 'rails_helper'
#
# RSpec.describe 'campaigns/new', type: :view do
#   before(:each) do
#     @organization = FactoryGirl.create(:organization)
#     assign(:campaign, Campaign.new(FactoryGirl.attributes_for(:campaign)))
#   end
#
#   it 'renders new campaign form' do
#     render
#
#     assert_select 'form[action=?][method=?]', organization_campaigns_path(@organization), 'post' do
#
#       assert_select 'input#campaign_name[name=?]', 'campaign[name]'
#
#     end
#   end
# end
