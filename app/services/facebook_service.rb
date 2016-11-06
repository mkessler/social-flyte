require 'koala'

class FacebookService
  def initialize(user, post)
    @graph = Koala::Facebook::API.new(user.facebook_authentication.token)
    @post_id = post.id
    @object_id = "#{post.network_parent_id}_#{post.network_post_id}"
  end

  def aggregate_reactions
    results = get_reactions
    build_reactions(results)

    results = results.next_page

    while results.present?
      build_reactions(results)
      results = results.next_page
    end
  end

  def aggregate_comments
    results = get_comments
    build_comments(results)

    results = results.next_page

    while results.present?
      build_comments(results)
      results = results.next_page
    end
  end

  def build_reactions(results)
    results.each do |result|
      Reaction.find_or_create_by(post_id: @post_id, network_user_id: result["id"]) do |reaction|
        reaction.network_user_link = result["link"]
        reaction.network_user_name = result["name"]
        reaction.network_user_picture = result["picture"]
        reaction.category = result["type"]
      end
    end
  end

  def build_comments(results)
    results.each do |result|
      Comment.find_or_create_by(post_id: @post_id, network_comment_id: result["id"]) do |comment|
        comment.network_user_id = result["from"]["id"]
        comment.network_user_name = result["from"]["name"]
        comment.like_count = result["like_count"]
        comment.message = result["message"]
      end
    end
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
