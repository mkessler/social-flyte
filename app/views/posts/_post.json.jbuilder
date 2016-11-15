json.extract! post, :id, :network_id, :network_post_id, :network_parent_id, :created_at, :updated_at
json.url organization_campaign_post_url(organization, campaign, post, format: :json)
