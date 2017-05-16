require 'rails_helper'

RSpec.feature 'Campaigns New', :type => :feature do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @organization = FactoryGirl.create(:organization)
    FactoryGirl.create(:membership, user: @user, organization: @organization)
    @campaign = FactoryGirl.create(:campaign, organization: @organization)
  end

  before(:each) do
    login_as(@user, :scope => :user)
  end

  scenario 'clicks submit with empty name' do
    visit new_organization_campaign_path(@organization)

    click_button 'Submit'

    expect(page).to have_selector('input.invalid')
    expect(page).to have_content('can\'t be blank')
  end

  scenario 'clicks submit with existing name' do
    visit new_organization_campaign_path(@organization)

    fill_in('Name', with: @campaign.name)
    click_button 'Submit'

    expect(page).to have_selector('input.invalid')
    expect(page).to have_content('has already been taken')
  end

  scenario 'clicks submit with valid form' do
    visit new_organization_campaign_path(@organization)

    fill_in('Name', with: 'Test Campaign')
    click_button 'Submit'

    #expect(page).to have_content('Campaign was successfully created.')
    expect(page).to have_text('Test Campaign')
  end
end
