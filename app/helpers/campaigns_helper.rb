module CampaignsHelper
  def campaign_networks_icons(campaign)
    icons = ''
    campaign.networks.each do |network_slug|
      icons += network_icon(network_slug)
    end

    icons.html_safe
  end

  def network_icon(network_slug)
    icon_class = (network_slug == 'facebook') ? network_slug + '-official' : network_slug
    content_tag(:i, nil, class: "fa fa-#{icon_class} fa-lg fa-fw", aria: { hidden: 'true' })
  end
end
