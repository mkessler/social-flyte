require 'rails_helper'

RSpec.feature 'Organizations Show', :type => :feature do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @organization = FactoryGirl.create(:organization)
    FactoryGirl.create(:membership, user: @user, organization: @organization)
    @campaign = FactoryGirl.create(:campaign, organization: @organization)
  end

  before(:each) do
    login_as(@user, :scope => :user)
  end

  scenario 'clicks campaign name' do
    visit organization_path(@organization)

    click_link @campaign.name

    expect(page).to have_text(@campaign.name)
  end

  scenario 'clicks new campaign' do
    visit organization_path(@organization)

    first(:xpath, "//a[@href='#{new_organization_campaign_path(@organization)}']").click

    expect(page).to have_selector("form#new_campaign")
  end

  scenario 'clicks edit icon' do
    visit organization_path(@organization)

    find(:xpath, "//a[@href='#{edit_organization_campaign_path(@organization, @campaign)}']").click

    expect(page).to have_selector("form#edit_campaign_#{@campaign.id}")
    expect(page).to have_field('Name', with: @campaign.name)
  end

  # scenario 'clicks delete icon' do
  #   visit organization_path(@organization)
  #
  #   accept_confirm do
  #     find(:xpath, "//a[@href='#{organization_campaign_path(@organization, @campaign)}'][@data-method='delete']").click
  #   end
  #
  #   expect(page).to have_content('Campaign was successfully destroyed.')
  # end
end
