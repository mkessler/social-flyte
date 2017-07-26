require 'active_record'
require 'activerecord-import'
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

  def user_details
    response = get_user
    {
      network_user_name: response['name'],
      network_user_image_url: response['picture']['data']['url']
    }
  end

  private

  def aggregate_comments
    results = get_comments
    build_comments(results)

    results = results.next_page

    while results.present?
      build_comments(results)
      results = results.next_page
    end
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

  def aggregate_shares
    results = get_shares
    build_shares(results)

    results = results.next_page

    while results.present?
      build_shares(results)
      results = results.next_page
    end
  end

  def build_comments(results)
    comments = []
    results.each do |result|
      comment = Comment.new(
        post_id: @post.id,
        network_comment_id: result['id'],
        network_user_id:  result['from']['id'],
        network_user_name: result['from']['name'],
        like_count: result['like_count'],
        message: result['message'],
        posted_at: result['created_time']
      )

      if result['attachment'].present?
        comment.attachment_image = result['attachment']['media']['image']['src'] if result['attachment']['media'].present?
        comment.attachment_url = result['attachment']['url']
      end

      comments << comment
    end

    Comment.import(
      comments,
      on_duplicate_key_update: {
        conflict_target: [:post_id, :network_comment_id],
        index_name: :index_comments_on_post_id_and_network_comment_id,
        columns: [
          :network_user_id,
          :network_user_name,
          :like_count,
          :message,
          :posted_at,
          :attachment_image,
          :attachment_url
        ]
      }
    )
  end

  def build_reactions(results)
    reactions = []
    results.each do |result|
      reaction = Reaction.new(
        post_id: @post.id,
        network_user_id: result['id'],
        network_user_name: result['name'],
        network_user_picture: result['pic_square'],
        category: result['type']
      )

      reactions << reaction
    end

    Reaction.import(
      reactions,
      on_duplicate_key_update: {
        conflict_target: [:post_id, :network_user_id],
        index_name: :index_reactions_on_post_id_and_network_user_id,
        columns: [:network_user_name, :network_user_picture, :category]
      }
    )
  end

  def build_shares(results)
    shares = []
    results.each do |result|
      share = Share.new(
        post_id: @post.id,
        network_share_id: result['id'],
        network_user_id:  result['from']['id'],
        network_user_name: result['from']['name']
      )

      shares << share
    end

    Share.import(
      shares,
      on_duplicate_key_update: {
        conflict_target: [:post_id, :network_share_id],
        index_name: :index_shares_on_post_id_and_network_share_id,
        columns: [:network_user_id, :network_user_name]
      }
    )
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
    @graph.get_object("#{@object_id}/sharedposts?fields=from,id&limit=1000")
  rescue Koala::Facebook::APIError => e
    Rails.logger.error("Koala::Facebook API Error (User ID: #{@user.id} | Post ID: #{@post.id}) - #{e.message}")
  end
end
