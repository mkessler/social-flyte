class InvitationMailer < ApplicationMailer
  default from: 'invitations@groala.com'

  def existing_user(invitation)
    @organization = invitation.organization
    @sender = User.find(invitation.sender_id)
    @recipient = User.find(invitiation.recipient_id)
    @url = ''
    mail(to: @recipient.email, subject: "You're invited to join #{@organization.name} on Groala")
  end

  def new_user(invitation)
    @organization = invitation.organization
    @sender = User.find(invitation.sender_id)
    @url = new_user_registration_url(email: invitation.email, invitation: invitation.token)
    mail(to: invitation.email, subject: "You're invited to join #{@organization.name} on Groala")
  end
end
