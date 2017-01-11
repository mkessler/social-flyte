module OrganizationsHelper
  def organization_title(organization)
    organization.campaigns.exists? ? organization.name : 'Welcome to groala'
  end

  def organization_title_class
    current_user.organizations.count > 1 ? 'dashboard-title extended-title-nav' : 'dashboard-title'
  end

  def organization_title_nav_class
    'extended-nav-1' if current_user.organizations.count > 1
  end
end
