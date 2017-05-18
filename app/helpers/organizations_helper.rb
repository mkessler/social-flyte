module OrganizationsHelper
  def organization_title(organization)
    organization.campaigns.present? ? organization.name : 'Welcome to groala'
  end

  def organization_sidenav_active_class(organization_id)
    organization_is_active?(organization_id) ? 'active' : ''
  end

  def organization_sidenav_subactive_class(organization_id, controller=nil, action=nil)
    organization_is_active?(organization_id) && (controller == params[:controller] || action == params[:action]) ? 'active' : ''
  end

  def organization_is_active?(organization_id)
    @organization.try(:id) == organization_id
  end
end
