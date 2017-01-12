require 'rails_helper'

RSpec.feature 'Campaigns New', :type => :feature do
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

  scenario 'clicks back' do
    visit new_organization_campaign_post_path(@organization, @campaign)
    find(:xpath, "//a[contains(@class, 'btn-floating')][@href='#{organization_campaign_path(@organization, @campaign)}']").click

    expect(page).to have_selector("div#posts-list")
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
  #     expect(page).to have_content('can\'t be blank')
  #   end
  #
  #   scenario 'clicks submit with empty page ID' do
  #     visit new_organization_campaign_post_path(@organization, @campaign)
  #
  #     fill_in('Post ID', with: 12345)
  #     click_button 'Submit'
  #
  #     expect(page).to have_selector('input.invalid')
  #     expect(page).to have_content('can\'t be blank')
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
