module OrganizationsHelper
  def organization_title(organization)
    organization.campaigns.present? ? organization.name : 'Welcome to groala'
  end

  def organization_title_class(user)
    user.organizations.count > 1 ? 'dashboard-title extended-title-nav' : 'dashboard-title'
  end
end
