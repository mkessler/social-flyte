class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, except: [:update]
  before_action :set_invitation, only: [:update, :destroy]

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
        format.json { render :show, status: :created, location: @invitation }
      else
        format.html { render :new }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /o/:organization_id/invitations/1
  # PATCH/PUT /o/:organization_id/invitations/1.json
  def update
    respond_to do |format|
      if update_invitation_params.present? && @invitation.update(update_invitation_params)
        format.html { redirect_to organizations_url, notice: 'Invitation accepted!' }
      else
        format.html { redirect_to organizations_url, notice: 'Invitation failed!' }
      end
    end
  end

  # DELETE /o/:organization_id/invitations/1
  # DELETE /o/:organization_id/invitations/1.json
  def destroy
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to invitations_url, notice: 'Invitation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = current_user.invitations.find(params[:id]) || current_user.sent_invitations.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params.require(:invitation).permit(:email).merge(sender_id: current_user.id)
    end

    def update_invitation_params
      params.require(:invitation).permit(:accepted)
    end
end
