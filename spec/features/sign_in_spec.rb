require 'rails_helper'

RSpec.feature 'User sign in', :type => :feature do
  let(:user) { FactoryGirl.create(:user) }

  scenario 'with valid credentials' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Submit'

    expect(page).to have_text(user.name)
  end

  scenario 'with invalid email' do
    visit new_user_session_path

    fill_in 'Email', with: Faker::Internet.free_email
    fill_in 'Password', with: user.password
    click_button 'Submit'

    expect(page).to have_text('Sign In')
  end

  scenario 'with invalid password' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: Faker::Lorem.characters(10)
    click_button 'Submit'

    expect(page).to have_text('Sign In')
  end

  scenario 'with empty email' do
    visit new_user_session_path

    fill_in 'Email', with: ''
    fill_in 'Password', with: user.password
    click_button 'Submit'

    expect(page).to have_text('Sign In')
  end

  scenario 'with empty password' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: ''
    click_button 'Submit'

    expect(page).to have_text('Sign In')
  end
end
