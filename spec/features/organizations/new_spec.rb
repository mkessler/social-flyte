# require 'rails_helper'
#
# RSpec.feature 'Organizations New', :type => :feature do
#   before(:all) do
#     @user = FactoryGirl.create(:user)
#     @organization = FactoryGirl.create(:organization)
#     FactoryGirl.create(:membership, user: @user, organization: @organization)
#   end
#
#   before(:each) do
#     login_as(@user, :scope => :user)
#   end
#
#   scenario 'clicks submit with empty name' do
#     visit new_organization_path
#
#     click_button 'Submit'
#
#     expect(page).to have_selector('input.invalid')
#     expect(page).to have_content('required')
#   end
#
#   scenario 'clicks submit with valid form' do
#     visit new_organization_path
#
#     fill_in('Name', with: 'Test Organization')
#     click_button 'Submit'
#
#     #expect(page).to have_content('Organization was successfully created.')
#     expect(page).to have_text('Test Organization')
#   end
# end
