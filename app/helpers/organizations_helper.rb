module OrganizationsHelper
  def organization_is_active?(organization_id)
    @organization.try(:id) == organization_id
  end

  def organization_sidenav_active_class(organization_id)
    organization_is_active?(organization_id) ? 'active' : ''
  end
end
