json.extract! campaign, :id, :organization_id, :name, :slug, :created_at, :updated_at
json.url organization_campaign_url(organization, campaign, format: :json)
