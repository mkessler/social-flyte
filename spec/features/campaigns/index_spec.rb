require 'rails_helper'

RSpec.feature 'Campaigns index', :type => :feature do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @organization = FactoryGirl.create(:organization)
    FactoryGirl.create(:membership, user: @user, organization: @organization)
    @campaign_one = FactoryGirl.create(:campaign, organization: @organization)
    @campaign_two = FactoryGirl.create(:campaign, organization: @organization, name: Faker::Beer.name)
  end

  before(:each) do
    login_as(@user, :scope => :user)
  end

  scenario 'clicks campaign name' do
    visit organization_campaigns_path(@organization)

    click_link @campaign_one.name

    expect(page).to have_text(@campaign_one.name)
  end

  # scenario 'clicks edit icon' do
  #   visit organization_campaigns_path(@organization)
  #
  #   # find(:xpath, "//a[@href='#{edit_organization_campaign_path(@organization, @campaign_one)}']").click
  #   find("tr[id='campaign-#{@campaign_one.id}'] a[class='edit-campaign']")
  #
  #   expect(page).to have_text('Editing Campaign')
  # end
  #
  # scenario 'clicks delete icon' do
  #   visit organization_campaigns_path(@organization)
  #
  #   find(:xpath, "//a[@href='#{organization_campaign_path(@organization, @campaign_one)}' @data-method='delete']").click
  #
  #   expect(page).to have_text('Campaigns')
  # end
end
