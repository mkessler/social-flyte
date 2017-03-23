module UsersHelper
  def facebook_user_name_for(user)
    if user.facebook_token.present?
      user.facebook_token.network_user_name || 'Fetching...'
    else
      'Not Connected'
    end
  end

  def facebook_user_image_url_for(user)
    if user.facebook_token.try(:network_user_image_url)
      image_tag(user.facebook_token.network_user_image_url, alt: user.name, class: 'rounded-circle img-responsive')
    else
      content_tag(:i, nil, class: 'fa fa-cubes fa-4x mt-2', aria: { hidden: true })
    end
  end

  def gravatar_for(user, size: 74)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?d=identicon&s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: 'gravatar rounded-circle')
  end
end
