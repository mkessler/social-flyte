require 'rails_helper'

RSpec.describe "invitations/new", type: :view do
  before(:each) do
    assign(:invitation, Invitation.new(
      :organization => nil,
      :sender_id => 1,
      :recipient_id => 1,
      :email => "MyString",
      :first_name => "MyString",
      :last_name => "MyString",
      :token => "MyString",
      :accepted => false
    ))
  end

  it "renders new invitation form" do
    render

    assert_select "form[action=?][method=?]", invitations_path, "post" do

      assert_select "input#invitation_organization_id[name=?]", "invitation[organization_id]"

      assert_select "input#invitation_sender_id[name=?]", "invitation[sender_id]"

      assert_select "input#invitation_recipient_id[name=?]", "invitation[recipient_id]"

      assert_select "input#invitation_email[name=?]", "invitation[email]"

      assert_select "input#invitation_first_name[name=?]", "invitation[first_name]"

      assert_select "input#invitation_last_name[name=?]", "invitation[last_name]"

      assert_select "input#invitation_token[name=?]", "invitation[token]"

      assert_select "input#invitation_accepted[name=?]", "invitation[accepted]"
    end
  end
end
