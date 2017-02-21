class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_campaign
  before_action :set_post, only: [:show, :interactions, :sync_status, :sync_post, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET o/:organization_id/c/:campaign_id/posts/:id
  # GET o/:organization_id/c/:campaign_id/posts/:id.json
  def show
    @network = @post.network
    set_meta_tags site: meta_title("#{@network.name} Post")
    @network_slug = @network.slug
    @status = ActiveJobStatus.fetch(@post.job_id)

    if @post.sync_count > 0
      flash[:notice] = 'This post is scheduled for another sync - occassionally refresh the page to for the latest status update.' if @status.queued?
      flash[:notice] = 'This post is currently syncing - occassionally refresh the page to for the latest status update.' if @status.working?
    end
  end

  # GET o/:organization_id/c/:campaign_id/posts/:id/interactions.json
  # GET o/:organization_id/c/:campaign_id/posts/:id/interactions.csv
  def interactions
    respond_to do |format|
      format.json { render json: FlaggedInteractionsDatatable.new(view_context, @post) }
      format.csv { send_data(@post.flagged_interactions_to_csv, :filename => "#{@post.campaign.name.parameterize}-#{@post.network.slug}-flagged-interactions-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv") }
    end
  end

  # GET o/:organization_id/c/:campaign_id/posts/:id/sync_status.json
  def sync_status
    status = ActiveJobStatus.fetch(@post.job_id)
    respond_to do |format|
      format.json { render json: status.to_json }
    end
  end

  # POST o/:organization_id/c/:campaign_id/posts/:id/sync_post.json
  def sync_post
    respond_to do |format|
      if @post.can_be_synced? && network_token_exists?(@post.network.slug) && @post.sync(current_user, session["#{@post.network.slug}_token"])
        format.json { render json: status.to_json }
      else
        format.json { render json: {error: true}.to_json, status: :unprocessable_entity }
      end
    end
  end

  # GET o/:organization_id/c/:campaign_id/p/new
  def new
    set_meta_tags site: meta_title('Import Post')
    add_breadcrumb 'Import Post', new_organization_campaign_post_path(@organization, @campaign)
    @post = @campaign.posts.new
  end

  # POST o/:organization_id/c/:campaign_id/posts
  # POST o/:organization_id/c/:campaign_id/posts.json
  def create
    @post = @campaign.posts.new(post_params)
    network = Network.find(post_params[:network_id])
    network_token_exists = network_token_exists?(network.slug)
    respond_to do |format|
      if network_token_exists && post_params.present? && @post.save
        @post.sync(current_user, session["#{network.slug}_token"])
        format.html { redirect_to organization_campaign_post_url(@organization, @campaign, @post), notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: organization_campaign_post_url(@organization, @campaign, @post) }
      else
        flash[:warning] = "Connected account required for #{network.name}" unless network_token_exists
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE o/:organization_id/c/:campaign_id/posts
  # DELETE o/:organization_id/c/:campaign_id/posts.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to organization_campaign_posts_url(@organization, @campaign), notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    # Don't allow :campaign_id
    def post_params
      params.require(:post).permit(:network_post_id, :network_parent_id, :sync_count, :synced_at).merge(network_id: Network.facebook.id)
    end

    def record_not_found
      if @organization.present? && @campaign.present?
        flash[:notice] = 'Uh-oh, looks like you tried to access a post that doesn\'t exist for this campaign.'
        redirect_to organization_campaign_url(@organization, @campaign)
      elsif @organization.present?
        flash[:notice] = 'Uh-oh, looks like you tried to access a campaign that doesn\'t exist for this organization.'
        redirect_to organization_campaigns_url(@organization)
      else
        flash[:notice] = 'Uh-oh, looks like you tried to access an organization that either doesn\'t exist or that you\'re not a member of.'
        redirect_to organizations_url
      end
    end
end
