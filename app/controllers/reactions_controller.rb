class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_campaign
  before_action :set_post
  before_action :set_reaction, only: [:update]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    respond_to do |format|
      format.json { render json: ReactionsDatatable.new(view_context, @post) }
      format.csv { send_data(@post.reactions.to_csv, :filename => "#{@post.campaign.name.parameterize}-#{@post.network.slug}-reactions-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv") }
    end
  end

  # PATCH/PUT organizations/:organization_id/c/:campaign_id/posts/:post_id/reactions/:id
  # PATCH/PUT organizations/:organization_id/c/:campaign_id/posts/:post_id/reactions/:id.json
  def update
    respond_to do |format|
      if reaction_params.present? && @reaction.update(reaction_params)
        format.js { render :update }
      end
    end
  end

  private
    def set_reaction
      @reaction = @post.reactions.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reaction_params
      params.require(:reaction).permit(:flagged)
    end

    def record_not_found
      if @organization.present? && @campaign.present? && @post.present
        flash[:notice] = 'Uh-oh, looks like you tried to access a reaction that doesn\'t exist for this post.'
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
