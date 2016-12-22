require 'rails_helper'

RSpec.feature 'Campaigns index', :type => :feature do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @organization = FactoryGirl.create(:organization)
    FactoryGirl.create(:membership, user: @user, organization: @organization)
    @campaign = FactoryGirl.create(:campaign, organization: @organization)
    @campaign_two = FactoryGirl.create(:campaign, organization: @organization, name: Faker::Beer.name)
  end

  before(:each) do
    login_as(@user, :scope => :user)
  end

  scenario 'clicks campaigns' do
    visit edit_organization_campaign_path(@organization, @campaign)

    find(:xpath, "//a[@class='nav-link'][@href='#{organization_path(@organization)}']").click

    expect(page).to have_selector("div#campaigns-list")
  end

  scenario 'clicks submit with empty name' do
    visit edit_organization_campaign_path(@organization, @campaign)

    fill_in('Name', with: '')
    click_button 'Submit'

    expect(page).to have_selector('input.invalid')
    expect(page).to have_content('can\'t be blank')
  end

  scenario 'clicks submit with existing name' do
    visit edit_organization_campaign_path(@organization, @campaign)

    fill_in('Name', with: @campaign_two.name)
    click_button 'Submit'

    expect(page).to have_selector('input.invalid')
    expect(page).to have_content('has already been taken')
  end

  scenario 'clicks submit with valid form' do
    visit edit_organization_campaign_path(@organization, @campaign)

    fill_in('Name', with: 'Test Campaign Two')
    click_button 'Submit'

    expect(page).to have_content('Campaign was successfully updated.')
    expect(page).to have_text('Test Campaign')
  end
end
