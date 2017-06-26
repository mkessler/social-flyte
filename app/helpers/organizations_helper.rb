module OrganizationsHelper
  def organization_title(organization)
    organization.campaigns.present? ? organization.name : 'Welcome to SocialFlyte'
  end

  def organization_sidenav_active_class(organization_id)
    organization_is_active?(organization_id) ? 'active' : ''
  end

  def organization_sidenav_arrow_class(organization_id)
    organization_is_active?(organization_id) ? 'rotate-element' : ''
  end

  def organization_sidenav_subactive_class(organization_id, controller=[], action=nil)
    organization_is_active?(organization_id) && (controller.include?(params[:controller]) || action == params[:action]) ? 'active' : ''
  end

  def organization_is_active?(organization_id)
    @organization.try(:id) == organization_id
  end
end
