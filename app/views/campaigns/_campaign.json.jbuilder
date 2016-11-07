json.extract! campaign, :id, :organization_id, :name, :slug, :created_at, :updated_at
json.url campaign_url(campaign, format: :json)