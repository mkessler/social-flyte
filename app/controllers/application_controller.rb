# Application Controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def set_organization
    if params[:organization_id]
      @organization = current_user.organizations.friendly.find(params[:organization_id])
    else
      @organization = current_user.organizations.friendly.find(params[:id])
    end
  end

  def set_campaign
    if params[:campaign_id]
      @campaign = @organization.campaigns.friendly.find(params[:campaign_id])
    else
      @campaign = @organization.campaigns.friendly.find(params[:id])
    end
  end

  def set_post
    @post = @campaign.posts.find(params[:id])
  end
end
