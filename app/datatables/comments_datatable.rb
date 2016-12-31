class CommentsDatatable
  delegate :params, :link_to, :content_tag, :tag, to: :@view

  def initialize(view, post)
    @view = view
    @post = post
  end

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
          date: comment.posted_at.strftime('%-d %b %Y')
        }
      }
    end
  end

  def comments
    @comments ||= fetch_comments
  end

  def fetch_comments
    comments = @post.comments.order("#{sort_column} #{sort_direction}")
    comments = comments.page(page).per(per_page)
    if params[:search].present?
      comments = comments.where("LOWER(network_user_name) like :search or LOWER(message) like :search", search: "%#{params[:search].try(:[], :value).downcase}%")
    end
    comments
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns = %w[like_count network_user_name message posted_at]
    columns[params[:order].try(:[], "0").try(:[], :column).to_i]
  end

  def sort_direction
    params[:order].try(:[], "0").try(:[], :dir) == "desc" ? "desc" : "asc"
  end
end
