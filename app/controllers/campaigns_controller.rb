class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_campaign, only: [:show, :edit, :update, :destroy, :flag_random_interaction, :interactions]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /o/:organization_id/c/:campaign_id
  # GET /o/:organization_id/c/:campaign_id.json
  def show
    set_meta_tags site: meta_title(@campaign.name)
    @csv_download_url = organization_campaign_interactions_path(@organization, @campaign, format: :csv)
    @flagged_interactions = @campaign.flagged_interactions
    @flag_random_comment_url = organization_campaign_flag_random_interaction_path(@organization, @campaign, interaction_class: 'comment')
    @flag_random_reaction_url = organization_campaign_flag_random_interaction_path(@organization, @campaign, interaction_class: 'reaction')
    @posts = @campaign.posts
  end

  # GET /o/:organization_id/c/:id/interactions.json
  # GET /o/:organization_id/c/:id/interactions.csv
  def interactions
    respond_to do |format|
      format.json { render json: FlaggedInteractionsDatatable.new(view_context, @campaign) }
      format.csv { send_data(@campaign.flagged_interactions_to_csv, :filename => "#{@campaign.name.parameterize}-flagged-interactions-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv") }
    end
  end

  # POST /o/:organization_id/c/:id/flag_random_reaction
  def flag_random_interaction
    post = @campaign.posts.select{|post| post.engagement_count > 0}.sample
    case params[:interaction_class]
      when 'comment'
        @interaction = post.comments.where(flagged: false).sample
        @flag_url = organization_campaign_post_comment_path(@organization, @campaign, post, @interaction, comment: { flagged: !@interaction.flagged })
      when 'reaction'
        @interaction = post.reactions.where(flagged: false).sample
        @flag_url = organization_campaign_post_reaction_path(@organization, @campaign, post, @interaction, reaction: { flagged: !@interaction.flagged })
    end

    @interaction.flagged = true

    respond_to do |format|
      if @interaction.save
        flash.now[:notice] = "#{@interaction.class.name} flagged!"
        format.js { render :flag_random_interaction }
      else
        format.js { render json: @interaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /o/:organization_id/c/:id/new
  def new
    set_meta_tags site: meta_title('New Campaign')
    add_breadcrumb 'New Campaign', new_organization_campaign_path(@organization)
    @campaign = @organization.campaigns.new
  end

  # GET /o/:organization_id/c/:id/edit
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
