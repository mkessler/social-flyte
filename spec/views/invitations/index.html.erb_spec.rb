require 'rails_helper'

RSpec.describe "invitations/index", type: :view do
  before(:each) do
    assign(:invitations, [
      Invitation.create!(
        :organization => nil,
        :sender_id => 2,
        :recipient_id => 3,
        :email => "Email",
        :first_name => "First Name",
        :last_name => "Last Name",
        :token => "Token",
        :accepted => false
      ),
      Invitation.create!(
        :organization => nil,
        :sender_id => 2,
        :recipient_id => 3,
        :email => "Email",
        :first_name => "First Name",
        :last_name => "Last Name",
        :token => "Token",
        :accepted => false
      )
    ])
  end

  it "renders a list of invitations" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Token".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
