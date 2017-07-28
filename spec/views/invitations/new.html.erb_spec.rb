# require 'rails_helper'
#
# RSpec.describe 'invitations/new', type: :view do
#   before(:each) do
#     @organization = FactoryGirl.create(:organization)
#     assign(:invitation, Invitation.new(
#       :organization => nil,
#       :sender_id => 1,
#       :email => Faker::Internet.email,
#       :accepted => false
#     ))
#   end
#
#   it 'renders new invitation form' do
#     render
#
#     assert_select 'form[action=?][method=?]', organization_invitations_path(@organization), 'post' do
#       assert_select 'input#invitation_email[name=?]', 'invitation[email]'
#     end
#   end
# end
