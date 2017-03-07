class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_campaign
  before_action :set_post
  before_action :set_comment, only: [:update]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    respond_to do |format|
      format.json { render json: CommentsDatatable.new(view_context, @post) }
      format.csv { send_data(@post.comments.to_csv, :filename => "#{@post.campaign.name.parameterize}-#{@post.network.slug}-comments-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv") }
    end
  end

  # PATCH/PUT organizations/:organization_id/c/:campaign_id/posts/:post_id/comments/:id
  # PATCH/PUT organizations/:organization_id/c/:campaign_id/posts/:post_id/comments/:id.json
  def update
    respond_to do |format|
      if comment_params.present? && @comment.update(comment_params)
        format.js { render :update }
      end
    end
  end

  private
  
  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:flagged)
  end

  def record_not_found
    if @organization.present? && @campaign.present? && @post.present
      flash[:notice] = 'Uh-oh, looks like you tried to access a comment that doesn\'t exist for this post.'
      redirect_to organization_campaign_url(@organization, @campaign)
    elsif @organization.present? && @campaign.present?
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
