module OrganizationsHelper
  def organization_title(organization)
    organization.campaigns.present? ? organization.name : 'Welcome to groala'
  end
end
