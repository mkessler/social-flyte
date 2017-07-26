class SharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_campaign
  before_action :set_post
  before_action :set_share, only: [:update]

  # GET /shares
  # GET /shares.json
  def index
    respond_to do |format|
      format.json { render json: SharesDatatable.new(view_context, @post) }
      format.csv { send_data(@post.shares.to_csv, :filename => "#{@post.campaign.name.parameterize}-#{@post.network.slug}-shares-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv") }
    end
  end

  # PATCH/PUT /shares/1
  # PATCH/PUT /shares/1.json
  def update
    respond_to do |format|
      if share_params.present? && @share.update(share_params)
        if @share.flagged?
          flash.now[:notice] = "Share flagged!"
        else
          flash.now[:warning] = "Share unflagged!"
        end
        format.js { render :update }
      else
        format.js { render json: @share.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_share
      @share = @post.shares.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def share_params
      params.require(:share).permit(:flagged)
    end

    def record_not_found
      if @organization.present? && @campaign.present? && @post.present
        flash[:notice] = 'Uh-oh, looks like you tried to access a share that doesn\'t exist for this post.'
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
