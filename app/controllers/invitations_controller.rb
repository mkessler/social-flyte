class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, except: [:update]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /o/:organization_id/invitations/new
  def new
    @invitation = @organization.invitations.new
  end

  # POST /o/:organization_id/invitations
  # POST /o/:organization_id/invitations.json
  def create
    @invitation = @organization.invitations.new(invitation_params)

    respond_to do |format|
      if @invitation.save
        InvitationMailer.invite_user(@invitation).deliver_later
        format.html { redirect_to @organization, notice: 'Invitation sent!' }
        format.json { render json: @invitation, status: :created }
      else
        format.html { render :new }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /o/:organization_id/invitations/1
  # PATCH/PUT /o/:organization_id/invitations/1.json
  def update
    @invitation = current_user.invitations.find(params[:id])
    respond_to do |format|
      if update_invitation_params.present? && @invitation.update(update_invitation_params)
        format.html { redirect_to organization_url(@invitation.organization), notice: 'Invitation accepted!' }
        format.json { render json: @invitation, status: :ok }
      else
        format.html { redirect_to organizations_url, notice: 'Invitation failed!' }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /o/:organization_id/invitations/1
  # DELETE /o/:organization_id/invitations/1.json
  def destroy
    @invitation = current_user.sent_invitations.find(params[:id])
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to @invitation.organization, notice: 'Invitation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params.require(:invitation).permit(:email).merge(sender_id: current_user.id)
    end

    def update_invitation_params
      params.require(:invitation).permit(:accepted)
    end

    def record_not_found
      if @organization.present?
        flash[:notice] = 'Uh-oh, looks like you tried to access an invitation that doesn\'t exist for this organization.'
        redirect_to organization_campaigns_url(@organization)
      else
        flash[:notice] = 'Uh-oh, looks like you tried to access an organization that either doesn\'t exist or that you\'re not a member of.'
        redirect_to organizations_url
      end
    end
end
