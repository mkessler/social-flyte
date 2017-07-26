class SharesDatatable < Datatable

  def as_json(options = {})
    {
      draw: params[:draw].to_i,
      recordsTotal: @post.shares.count,
      recordsFiltered: shares.total_count,
      data: data
      #add error message https://datatables.net/manual/server-side#Returned-data
    }
  end

  private

  def data
    shares.map do |share|
      {
        network_share_id: share.network_share_id,
        user: {
          name: share.network_user_name,
          url: @post.network.user_link(share.network_user_id)
        },
        flagged: {
          id: share.id,
          status: share.flagged,
          url: organization_campaign_post_share_path(@organization, @campaign, @post, share, share: { flagged: !share.flagged })
        }
      }
    end
  end

  def shares
    @shares ||= fetch_shares
  end

  def fetch_shares
    shares = @post.shares.order("#{sort_column} #{sort_direction}")
    shares = shares.page(page).per(per_page)
    if params[:search].present?
      shares = shares.where("LOWER(network_user_name) like :search", search: "%#{params[:search].try(:[], :value).downcase}%")
    end
    shares
  end

  def sort_column
    columns = %w[network_share_id network_user_name flagged]
    columns[params[:order].try(:[], "0").try(:[], :column).to_i]
  end
end
