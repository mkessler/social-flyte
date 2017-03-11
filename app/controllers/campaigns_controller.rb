class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_campaign, only: [:show, :edit, :update, :destroy, :interactions]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /o/:organization_id/c/:campaign_id
  # GET /o/:organization_id/c/:campaign_id.json
  def show
    set_meta_tags site: meta_title(@campaign.name)
    @posts = @campaign.posts
    @flagged_interactions = @campaign.flagged_interactions
  end

  # GET /o/:organization_id/c/:campaign_id/interactions.json
  # GET /o/:organization_id/c/:campaign_id/interactions.csv
  def interactions
    respond_to do |format|
      format.json { render json: FlaggedInteractionsDatatable.new(view_context, @campaign) }
      format.csv { send_data(@campaign.flagged_interactions_to_csv, :filename => "#{@campaign.name.parameterize}-flagged-interactions-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv") }
    end
  end

  # GET /o/:organization_id/c/:campaign_id/new
  def new
    set_meta_tags site: meta_title('New Campaign')
    add_breadcrumb 'Add Campaign', new_organization_campaign_path(@organization)
    @campaign = @organization.campaigns.new
  end

  # GET /o/:organization_id/c/:campaign_id/edit
  def edit
    set_meta_tags site: meta_title("Edit #{@campaign.name}")
    add_breadcrumb 'Edit', edit_organization_campaign_path(@organization)
  end

  # POST /o/:organization_id/c/:campaign_id
  # POST /o/:organization_id/c/:campaign_id.json
  def create
    @campaign = @organization.campaigns.new(campaign_params)

    respond_to do |format|
      if campaign_params.present? && @campaign.save
        format.html { redirect_to organization_campaign_url(@organization, @campaign), notice: 'Campaign was successfully created.' }
        format.json { render :show, status: :created, location: organization_campaign_url(@organization, @campaign) }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /o/:organization_id/c/:campaign_id
  # PATCH/PUT /o/:organization_id/c/:campaign_id.json
  def update
    respond_to do |format|
      if campaign_params.present? && @campaign.update(campaign_params)
        format.html { redirect_to organization_campaign_url(@organization, @campaign), notice: 'Campaign was successfully updated.' }
        format.json { render :show, status: :ok, location: organization_campaign_url(@organization, @campaign) }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /o/:organization_id/c/:campaign_id
  # DELETE /o/:organization_id/c/:campaign_id.json
  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to organization_campaigns_url(@organization), notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
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
