require 'rails_helper'

RSpec.feature 'Organizations Edit', :type => :feature do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @organization = FactoryGirl.create(:organization)
    FactoryGirl.create(:membership, user: @user, organization: @organization)
  end

  before(:each) do
    login_as(@user, :scope => :user)
  end

  scenario 'clicks submit with empty name' do
    visit edit_organization_path(@organization)

    fill_in('Name', with: '')
    click_button 'Submit'

    expect(page).to have_selector('input.invalid')
    expect(page).to have_content('can\'t be blank')
  end

  scenario 'clicks submit with valid form' do
    visit edit_organization_path(@organization)

    fill_in('Name', with: 'Test Organization Two')
    click_button 'Submit'

    #expect(page).to have_content('Organization was successfully updated.')
    expect(page).to have_text('Test Organization Two')
  end
end
