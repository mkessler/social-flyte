# require 'rails_helper'
#
# RSpec.feature 'User sign up', :type => :feature do
#   scenario 'with valid credentials' do
#     visit new_user_registration_path
#
#     first_name = Faker::Name.first_name
#     last_name = Faker::Name.last_name
#
#     fill_in 'First Name', with: first_name
#     fill_in 'Last Name', with: last_name
#     fill_in 'Email', with: Faker::Internet.free_email
#     fill_in 'Password', with: Faker::Lorem.characters(10)
#     click_button 'Submit'
#
#     expect(page).to have_text("#{first_name} #{last_name}")
#   end
#
#   scenario 'with invalid password' do
#     visit new_user_registration_path
#
#     fill_in 'First Name', with: Faker::Name.first_name
#     fill_in 'Last Name', with: Faker::Name.last_name
#     fill_in 'Email', with: Faker::Internet.free_email
#     fill_in 'Password', with: Faker::Lorem.characters(3)
#     click_button 'Submit'
#
#     expect(page).to have_text('is too short (minimum is 6 characters)')
#   end
#
#   scenario 'with empty first name' do
#     visit new_user_registration_path
#
#     fill_in 'First Name', with: ''
#     fill_in 'Last Name', with: Faker::Name.last_name
#     fill_in 'Email', with: Faker::Internet.free_email
#     fill_in 'Password', with: Faker::Lorem.characters(10)
#     click_button 'Submit'
#
#     expect(page).to have_text('can\'t be blank')
#   end
#
#   scenario 'with empty last name' do
#     visit new_user_registration_path
#
#     fill_in 'First Name', with: Faker::Name.first_name
#     fill_in 'Last Name', with: ''
#     fill_in 'Email', with: Faker::Internet.free_email
#     fill_in 'Password', with: Faker::Lorem.characters(10)
#     click_button 'Submit'
#
#     expect(page).to have_text('can\'t be blank')
#   end
#
#   scenario 'with empty email' do
#     visit new_user_registration_path
#
#     fill_in 'First Name', with: Faker::Name.first_name
#     fill_in 'Last Name', with: Faker::Name.last_name
#     fill_in 'Email', with: ''
#     fill_in 'Password', with: Faker::Lorem.characters(10)
#     click_button 'Submit'
#
#     expect(page).to have_text('can\'t be blank')
#   end
#
#   scenario 'with empty password' do
#     visit new_user_registration_path
#
#     fill_in 'First Name', with: Faker::Name.first_name
#     fill_in 'Last Name', with: Faker::Name.last_name
#     fill_in 'Email', with: Faker::Internet.free_email
#     fill_in 'Password', with: ''
#     click_button 'Submit'
#
#     expect(page).to have_text('can\'t be blank')
#   end
# end
