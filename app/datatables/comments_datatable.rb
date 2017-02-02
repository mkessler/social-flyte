class CommentsDatatable < Datatable

  def as_json(options = {})
    {
      draw: params[:draw].to_i,
      recordsTotal: @post.comments.count,
      recordsFiltered: comments.total_count,
      data: data
      #add error message https://datatables.net/manual/server-side#Returned-data
    }
  end

private

  def data
    comments.map do |comment|
      {
        like_count: comment.like_count,
        user: {
          name: comment.network_user_name,
          url: @post.network.user_link(comment.network_user_id)
        },
        comment: {
          attachment: {
            image: comment.attachment_image,
            url: comment.attachment_url
          },
          message: comment.message
        },
        posted_at: {
          time: comment.posted_at.strftime('%l:%M%P'),
          date: comment.posted_at.strftime('%b %-d %Y')
        },
        flagged: {
          id: comment.id,
          status: comment.flagged,
          url: organization_campaign_post_comment_path(@organization, @campaign, @post, comment, comment: { flagged: !comment.flagged })
        }
      }
    end
  end

  def comments
    @comments ||= fetch_comments
  end

  def fetch_comments
    if sort_column == 'message'
      comments = @post.comments.order("LENGTH(#{sort_column}) #{sort_direction}")
    else
      comments = @post.comments.order("#{sort_column} #{sort_direction}")
    end
    comments = comments.page(page).per(per_page)
    if params[:search].present?
      comments = comments.where("LOWER(network_user_name) like :search or LOWER(message) like :search", search: "%#{params[:search].try(:[], :value).downcase}%")
    end
    comments
  end

  def sort_column
    columns = %w[like_count network_user_name message posted_at flagged]
    columns[params[:order].try(:[], "0").try(:[], :column).to_i]
  end
end
