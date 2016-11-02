require 'koala'

class FacebookService
  def initialize(user, parent_id, post_id)
    @graph = Koala::Facebook::API.new(user.facebook_authentication.token)
    @object_id = "#{parent_id}_#{post_id}"
  end

  def get_post
    @graph.get_object("#{@object_id}?fields=from,created_time,permalink_url")
  end

  def get_comments
    @graph.get_object("#{@object_id}/comments?fields=attachment,created_time,from,id,like_count,message,parent&limit=1000")
  end

  def get_reactions
    @graph.get_object("#{@object_id}/reactions?fields=id,link,name,pic_square,type&limit=2000")
  end

  def get_shares
    @graph.get_object("#{@object_id}/sharedposts?limit=5000")
  end
end
