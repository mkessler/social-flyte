require 'koala'

class FacebookService
  def initialize(user, post=nil)
    @user = user
    @token = user.facebook_token
    @graph = Koala::Facebook::API.new(@token.token)
    @post = post
    @object_id = "#{@post.network_parent_id}_#{@post.network_post_id}" if @post.present?
  end

  def sync
    if @post.network == Network.facebook
      aggregate_comments
      aggregate_reactions
      @post.reload
      @post.update_sync_status
    else
      false
    end
  end

  def update_user_details
    response = get_user
    @token.network_user_name = response['name']
    @token.network_user_image_url = response['picture']['data']['url']
    @token.save
  end

  private

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
      @post.reactions.find_or_create_by(network_user_id: result['id']) do |reaction|
        reaction.network_user_name = result['name']
        reaction.network_user_picture = result['pic_square']
        reaction.category = result['type']
      end
    end
  end

  def build_comments(results)
    results.each do |result|
      @post.comments.find_or_create_by(network_comment_id: result['id']) do |comment|
        comment.network_user_id = result['from']['id']
        comment.network_user_name = result['from']['name']
        comment.like_count = result['like_count']
        comment.message = result['message']
        comment.posted_at = result['created_time']
        if result['attachment'].present?
          comment.attachment_image = result['attachment']['media']['image']['src'] if result['attachment']['media'].present?
          comment.attachment_url = result['attachment']['url']
        end
      end
    end
  end

  def get_user
    @graph.get_object("me?fields=id,name,picture.type(large)")
  rescue Koala::Facebook::APIError => e
    Rails.logger.error("Koala::Facebook API Error (User ID: #{@user.id}) - #{e.message}")
  end

  def get_post
    @graph.get_object("#{@object_id}?fields=from,created_time,permalink_url")
  rescue Koala::Facebook::APIError => e
    Rails.logger.error("Koala::Facebook API Error (User ID: #{@user.id} | Post ID: #{@post.id}) - #{e.message}")
  end

  def get_comments
    @graph.get_object("#{@object_id}/comments?fields=attachment,created_time,from,id,like_count,message,parent&limit=500")
  rescue Koala::Facebook::APIError => e
    Rails.logger.error("Koala::Facebook API Error (User ID: #{@user.id} | Post ID: #{@post.id}) - #{e.message}")
  end

  def get_reactions
    @graph.get_object("#{@object_id}/reactions?fields=id,name,pic_square,type&limit=1000")
  rescue Koala::Facebook::APIError => e
    Rails.logger.error("Koala::Facebook API Error (User ID: #{@user.id} | Post ID: #{@post.id}) - #{e.message}")
  end

  def get_shares
    @graph.get_object("#{@object_id}/sharedposts?limit=1000")
  rescue Koala::Facebook::APIError => e
    Rails.logger.error("Koala::Facebook API Error (User ID: #{@user.id} | Post ID: #{@post.id}) - #{e.message}")
  end
end
