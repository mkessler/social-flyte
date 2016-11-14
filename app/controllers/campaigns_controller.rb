class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET organizations/friendly_id/campaigns/friendly_id
  # GET organizations/friendly_id/campaigns/friendly_id.json
  def index
    @campaigns = @organization.campaigns
  end

  # GET organizations/friendly_id/campaigns/friendly_id
  # GET organizations/friendly_id/campaigns/friendly_id.json
  def show
  end

  # GET organizations/friendly_id/campaigns/friendly_id/new
  def new
    @campaign = @organization.campaigns.new
  end

  # GET organizations/friendly_id/campaigns/friendly_id/edit
  def edit
  end

  # POST organizations/friendly_id/campaigns/friendly_id
  # POST organizations/friendly_id/campaigns/friendly_id.json
  def create
    @campaign = @organization.campaigns.new(campaign_params)

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to organization_campaign_url(@organization, @campaign), notice: 'Campaign was successfully created.' }
        format.json { render :show, status: :created, location: organization_campaign_url(@organization, @campaign) }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT organizations/friendly_id/campaigns/friendly_id
  # PATCH/PUT organizations/friendly_id/campaigns/friendly_id.json
  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html { redirect_to organization_campaign_url(@organization, @campaign), notice: 'Campaign was successfully updated.' }
        format.json { render :show, status: :ok, location: organization_campaign_url(@organization, @campaign) }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE organizations/friendly_id/campaigns/friendly_id
  # DELETE organizations/friendly_id/campaigns/friendly_id.json
  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to organization_campaigns_url(@organization), notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = @organization.campaigns.friendly.find(params[:id])
    end

    def set_organization
      @organization = current_user.organizations.friendly.find(params[:organization_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # Don't allow :organization_id, :slug
    def campaign_params
      params.require(:campaign).permit(:name)
    end

    def record_not_found
      if @organization.present?
        flash[:notice] = 'Uh-oh, looks like you tried to access a campaign that doesn\'t exist for this organization.'
        redirect_to organization_campaigns_url(@organization)
      else
        flash[:notice] = 'Uh-oh, looks like you tried to access an organization that either doesn\'t exist or that you\'re not a member of.'
        redirect_to organizations_url
      end
    end
end
