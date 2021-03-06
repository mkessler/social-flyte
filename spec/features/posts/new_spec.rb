require 'rails_helper'

RSpec.feature 'Campaigns New', :type => :feature do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @post = FactoryGirl.create(:post, user: @user)
  end

  before(:each) do
    login_as(@user, :scope => :user)
  end

  # context 'with user access token' do
  #   before(:all) do
  #     FactoryGirl.create(:authentication, user: @user)
  #   end
  #
  #   scenario 'clicks submit with empty post ID' do
  #     visit new_organization_campaign_post_path(@organization, @campaign)
  #
  #     fill_in('Page ID', with: 12345)
  #     click_button 'Submit'
  #
  #     expect(page).to have_selector('input.invalid')
  #     expect(page).to have_content('required')
  #   end
  #
  #   scenario 'clicks submit with empty page ID' do
  #     visit new_organization_campaign_post_path(@organization, @campaign)
  #
  #     fill_in('Post ID', with: 12345)
  #     click_button 'Submit'
  #
  #     expect(page).to have_selector('input.invalid')
  #     expect(page).to have_content('required')
  #   end
  #
  #   scenario 'clicks submit with existing post ID' do
  #     visit new_organization_campaign_post_path(@organization, @campaign)
  #
  #     fill_in('Post ID', with: @post.network_post_id)
  #     click_button 'Submit'
  #
  #     expect(page).to have_selector('input.invalid')
  #     expect(page).to have_content('has already been taken')
  #   end
  #
  #   scenario 'clicks submit with valid form' do
  #     visit new_organization_campaign_post_path(@organization, @campaign)
  #
  #     fill_in('Post ID', with: 12345)
  #     fill_in('Page ID', with: 12345)
  #     click_button 'Submit'
  #
  #     #expect(page).to have_content('Campaign was successfully created.')
  #     #expect(page).to have_text('Test Campaign')
  #   end
  # end
end
