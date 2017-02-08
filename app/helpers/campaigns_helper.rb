module CampaignsHelper
  def campaign_networks_icons(campaign)
    icons = ''
    campaign.networks.each do |network|
      icons = icons + content_tag(:i, nil, class: "fa fa-#{network}-official fa-lg")
    end

    icons.html_safe
  end
end
