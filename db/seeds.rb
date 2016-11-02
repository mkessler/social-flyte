['Facebook', 'Twitter', 'Instagram'].each do |network|
  Network.create(name: network, slug: network.underscore)
end
