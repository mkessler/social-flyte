require 'rails_helper'

RSpec.describe "invitations/show", type: :view do
  before(:each) do
    @invitation = assign(:invitation, Invitation.create!(
      :organization => nil,
      :sender_id => 2,
      :recipient_id => 3,
      :email => "Email",
      :first_name => "First Name",
      :last_name => "Last Name",
      :token => "Token",
      :accepted => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Token/)
    expect(rendered).to match(/false/)
  end
end
