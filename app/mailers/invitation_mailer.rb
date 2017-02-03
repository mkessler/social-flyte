class InvitationMailer < ApplicationMailer
  default from: 'invitations@groala.com'

  def invite_user(invitation)
    @invitation = invitation
    @organization = invitation.organization
    @sender = User.find(invitation.sender_id)
    if invitation.recipient_id
      @url = edit_user_registration_url
    else
      @url = new_user_registration_url(email: invitation.email, invitation: invitation.token)
    end
    mail(to: invitation.email, subject: "You're invited to join #{@organization.name} on Groala")
  end
end
