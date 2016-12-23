require 'rails_helper'

RSpec.feature 'Campaigns Show', :type => :feature do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @organization = FactoryGirl.create(:organization)
    FactoryGirl.create(:membership, user: @user, organization: @organization)
    @campaign = FactoryGirl.create(:campaign, organization: @organization)
    @post = FactoryGirl.create(:post, campaign: @campaign)
  end

  before(:each) do
    login_as(@user, :scope => :user)
  end

  scenario 'clicks post name' do
    visit organization_campaign_path(@organization, @campaign)

    click_link @post.network.name

    expect(page).to have_text(@post.network_post_id)
  end

  scenario 'clicks add' do
    visit organization_campaign_path(@organization, @campaign)

    find(:xpath, "//a[@href='#{new_organization_campaign_post_path(@organization, @campaign)}']").click

    expect(page).to have_selector("form#new_post")
  end

  # scenario 'clicks delete icon' do
  #   visit organization_campaign_path(@organization, @campaign)
  #
  #   accept_confirm do
  #     find(:xpath, "//a[@href='#{organization_campaign_path(@organization, @campaign)}'][@data-method='delete']").click
  #   end
  #
  #   expect(page).to have_content('Campaign was successfully destroyed.')
  # end
end
