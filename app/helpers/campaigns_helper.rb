module CampaignsHelper
  def campaign_networks_icons(campaign)
    icons = ''
    campaign.networks.each do |network_slug|
      icons += network_icon(network_slug, 'mx-quarter')
    end

    icons.html_safe
  end

  def network_icon(network_slug, additional_class=nil)
    icon_class = (network_slug == 'facebook') ? network_slug + '-official' : network_slug
    content_tag(:i, nil, class: "fa fa-#{icon_class} fa-lg fa-fw #{additional_class}", aria: { hidden: 'true' })
  end
end
