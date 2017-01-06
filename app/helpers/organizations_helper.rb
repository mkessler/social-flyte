module OrganizationsHelper
  def organization_title(organization)
    organization.campaigns.exists? ? organization.name : 'Welcome to groala'
  end
end
