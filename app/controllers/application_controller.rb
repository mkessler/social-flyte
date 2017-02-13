# Application Controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_tags

  def network_token_exists?(network_name)
    session["#{network_name}_token"].present? && Time.now.utc < session["#{network_name}_token_expires_at"]
  end

  def meta_title(title=nil)
    title.present? ? "Groala | #{title}" : 'Groala'
  end

  def set_tags
    set_meta_tags site: meta_title,
                  description: 'Groala is the easiest way to monitor and analyze your native social promotions.',
                  keywords: 'Groala, Social, Media, Promotion, Contest, Platform, Analyze, Monitor, Native'
  end

  def set_organization
    if params[:organization_id]
      @organization = current_user.organizations.friendly.find(params[:organization_id])
    else
      @organization = current_user.organizations.friendly.find(params[:id])
    end
    add_breadcrumb 'My Organizations', root_url if current_user.organizations.count > 1
    add_breadcrumb @organization.name, organization_path(@organization)
  end

  def set_campaign
    if params[:campaign_id]
      @campaign = @organization.campaigns.friendly.find(params[:campaign_id])
    else
      @campaign = @organization.campaigns.friendly.find(params[:id])
    end
    add_breadcrumb @campaign.name, organization_campaign_path(@organization, @campaign)
  end

  def set_post
    if params[:post_id]
      @post = @campaign.posts.find(params[:post_id])
    else
      @post = @campaign.posts.find(params[:id])
    end
    add_breadcrumb '<i class="fa fa-facebook-official fa-lg" aria-hidden="true"></i>', organization_campaign_post_path(@organization, @campaign, @post)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end
