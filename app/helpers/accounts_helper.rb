module AccountsHelper
  def account_user_name(token=nil)
    if token.present?
      token.network_user_name.present? ? token.network_user_name : 'Connected'
    else
      'Not Connected'
    end
  end

  def account_user_image(token=nil)
    if token.present?
      if token.network_user_image_url.present?
        image_tag(token.network_user_image_url, alt: token.network_user_name, class: 'rounded-circle img-responsive')
      else
        account_connected_missing_profile_image
      end
    else
      account_disconnected_missing_profile_image
    end
  end

  def account_connected_missing_profile_image
    content_tag(:i, nil, class: 'fa fa-user fa-4x green-text mt-2', aria: { hidden: true })
  end

  def account_disconnected_missing_profile_image
    content_tag(:i, nil, class: 'fa fa-user fa-4x mt-2', aria: { hidden: true })
  end
end
