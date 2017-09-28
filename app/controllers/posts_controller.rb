class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :add_post_breadcrumb
  before_action :set_post, only: [:show, :flag_random_interaction, :interactions, :sync_status, :sync_post, :destroy]
  before_action :facebook_token_validation_check, only: [:sync_post]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET posts
  # GET posts.json
  def index
    set_meta_tags site: meta_title("Posts")
    add_breadcrumb 'Home', posts_url
    @posts = current_user.posts
  end

  # GET posts/:id
  # GET posts/:id.json
  def show
    @csv_download_url = post_interactions_path(@post, format: :csv)
    @flag_random_comment_url = post_flag_random_interaction_path(@post, interaction_class: 'comment')
    @flag_random_reaction_url = post_flag_random_interaction_path(@post, interaction_class: 'reaction')
    @flag_random_share_url = post_flag_random_interaction_path(@post, interaction_class: 'share')
    @network = @post.network
    @network_slug = @network.slug
    @status = ActiveJobStatus.fetch(@post.job_id)
    set_meta_tags site: meta_title("#{@network.name} Post")

    if @post.sync_count > 0
      flash[:notice] = 'This post is scheduled for another sync - occassionally refresh the page to for the latest status update.' if @status.queued?
      flash[:notice] = 'This post is currently syncing - occassionally refresh the page to for the latest status update.' if @status.working?
    end
  end

  # GET posts/:id/interactions.json
  # GET posts/:id/interactions.csv
  def interactions
    respond_to do |format|
      format.json { render json: FlaggedInteractionsDatatable.new(view_context, @post) }
      format.csv { send_data(@post.flagged_interactions_to_csv, :filename => "#{@post.name.parameterize}-#{@post.network.slug}-flagged-interactions-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv") }
    end
  end

  # POST /posts/:id/flag_random_reaction
  def flag_random_interaction
    case params[:interaction_class]
      when 'comment'
        @interaction = @post.comments.where(flagged: false).sample
        @flag_url = post_comment_path(@post, @interaction, comment: { flagged: !@interaction.flagged })
      when 'reaction'
        @interaction = @post.reactions.where(flagged: false).sample
        @flag_url = post_reaction_path(@post, @interaction, reaction: { flagged: !@interaction.flagged })
      when 'share'
        @interaction = @post.shares.where(flagged: false).sample
        @flag_url = post_share_path(@post, @interaction, share: { flagged: !@interaction.flagged })
    end

    @interaction.flagged = true

    respond_to do |format|
      if @interaction.save
        flash[:notice] = "#{@interaction.class.name} flagged!"
        format.js { render :flag_random_interaction }
      else
        format.js { render json: @interaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET posts/:id/sync_status.json
  def sync_status
    status = ActiveJobStatus.fetch(@post.job_id)
    respond_to do |format|
      format.json { render json: status.to_json }
    end
  end

  # POST posts/:id/sync_post.json
  def sync_post
    respond_to do |format|
      if @post.can_be_synced? && @post.sync(current_user)
        format.json { render json: status.to_json }
      else
        format.json { render json: {error: true}.to_json, status: :unprocessable_entity }
      end
    end
  end

  # GET posts/new
  def new
    set_meta_tags site: meta_title('Import Post')
    add_breadcrumb 'Import', new_post_path
    @post = current_user.posts.new
  end

  def manual_import
    set_meta_tags site: meta_title('Manually Import Post')
    add_breadcrumb 'Manual Import', manual_import_posts_path
    @post = current_user.posts.new
  end

  # POST posts
  # POST posts.json
  def create
    @post = current_user.posts.new(post_params)
    respond_to do |format|
      if post_params.present? && @post.save
        @post.sync(current_user)
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        flash[:warning] = "Required fields missing."
        @form_errors = true
        format.html {
          if params[:is_manual_import]
            render :new && return
          else
            render :new && return
          end
        }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE posts
  # DELETE posts.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  # Don't allow :user_id
  def post_params
    params.require(:post).permit(:name, :network_post_id, :network_parent_id, :sync_count, :synced_at).merge(network_id: Network.facebook.id)
  end

  def record_not_found
    flash[:notice] = 'Uh-oh, looks like you tried to access a post that doesn\'t exist.'
    redirect_to posts_url
  end

  def add_post_breadcrumb
    add_breadcrumb 'Posts', posts_url
  end

  def facebook_token_validation_check
    unless current_user.has_valid_facebook_token?
      flash[:error] = "Facebook token is currently expired. Please try syncing again."
      redirect_to :show
    end
  end
end
