['Facebook', 'Twitter', 'Instagram'].each do |network|
  Network.create(name: network)
end

if Rails.env.development?
  user = User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: 'user@example.com',
    password: 'password'
  )

  organization = Organization.create(
    name: Faker::Space.company
  )

  twitter_token = TwitterToken.create(
    organization: organization,
    network_user_id: 109068078,
    token: Rails.application.secrets.twitter_access_token,
    secret: Rails.application.secrets.twitter_access_token_secret,
    network_user_name: 'mikaelkessler'
  )

  Membership.create(user: user, organization: organization)

  ["#{Faker::Space.nasa_space_craft} Contest", "#{Faker::Space.nasa_space_craft} Contest", "#{Faker::Space.nasa_space_craft} Contest"].each do |campaign|
    Campaign.create(organization: organization, name: campaign)
  end

  Post.create(network: Network.facebook, campaign: Campaign.first, network_post_id: '10154368835501263', network_parent_id: '68680511262')
  Post.create(network: Network.twitter, campaign: Campaign.first, network_post_id: '614092454652981248', twitter_token_id: twitter_token.id)
end
